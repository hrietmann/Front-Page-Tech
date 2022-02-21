//
//  PodcastViewModel.swift
//  FPT
//
//  Created by Hans Rietmann on 14/02/2022.
//

import SwiftUI
import Combine
import MediaPlayer



@MainActor
class PodcastViewModel: ObservableObject, BackgroundPlayerManager {
    
    
    @Published private(set) var isLoadingPodcast = false
    @Published private(set) var podcast: Podcast?
    @Published private(set) var podcastError: Error?
    @Published var presentedEpisode: PodcastEpisode?
    
    enum PlayerState: Equatable {
        case idle
        case playing(episode: PodcastEpisode)
        case paused(episode: PodcastEpisode)
        
        var isIdle: Bool {
            switch self {
            case .idle: return true
            default: return false
            }
        }
        var isPlaying: Bool {
            switch self {
            case .playing: return true
            default: return false
            }
        }
        var isPaused: Bool {
            switch self {
            case .paused: return true
            default: return false
            }
        }
        var episode: PodcastEpisode? {
            switch self {
            case .idle: return nil
            case .playing(let episode): return episode
            case .paused(let episode): return episode
            }
        }
        static func ==(lhs: Self, rhs: Self) -> Bool {
            if lhs.isIdle, rhs.isIdle { return true }
            guard lhs.episode?.id == rhs.episode?.id else { return false }
            return lhs.isPlaying == rhs.isPlaying
        }
    }
    @Published private(set) var playerState = PlayerState.idle { didSet { updateBackgroundPlayerInfos() } }
    private(set) var player: PodcastPlayer?
    @Published private(set) var isLoadingPlay = false { didSet { updateBackgroundPlayerInfos() } }
    @Published private(set) var playError: Error?
    @Published private(set) var playingEpisodeElapsedTime: Double = 0 { didSet { updateBackgroundPlayerInfos() } }
    @Published private(set) var playingEpisodeRate: Double = 1 { didSet { updateBackgroundPlayerInfos() } }
    @Published var volume: Double = Double(AVAudioSession.sharedInstance().outputVolume) {
        didSet {
            let volumeView = MPVolumeView()
            let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) { [weak self] in
                guard let volume = self?.volume else { return }
                slider?.value = Float(volume)
            }
        }
    }
    
    private var observers: Set<AnyCancellable>?
    
    
    init() {
        loadPodcast()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    
    @objc private func willResignActiveNotification() {
        guard let episode = playerState.episode, playerState.isPlaying else { return }
        self.updateBackgroundPlayerInfos()
        Task { try? await player?.play(episode: episode) }
    }
    
    
    func loadPodcast() {
        guard !isLoadingPodcast else { return }
        isLoadingPodcast = true
        podcastError = nil
        
        Task.detached {
            
            let result: Result<Podcast,Error>
            do { result = .success(try await PodcastDownloader().podcast) }
            catch { result = .failure(error) }
            
            Task { @MainActor [weak self] in
                self?.isLoadingPodcast = false
                switch result {
                case .failure(let error): self?.podcastError = error
                case .success(let podcast): self?.podcast = podcast
                }
            }
        }
    }
    
    
    func isPlaying(_ episode: PodcastEpisode) -> Bool { playerState.episode?.id == episode.id && playerState.isPlaying && !isLoadingPlay }
    
    
    nonisolated func play(episode: PodcastEpisode) {
        Task.detached {
            guard await !self.isLoadingPlay else { return }
            await self.set(isLoadingPlay: true)
            await self.set(playError: nil)
            
            let result: Result<(),Error>
            do {
                try await self.player(for: episode).play(episode: episode)
                result = .success(())
            } catch { result = .failure(error) }
            
            Task { @MainActor in
                switch result {
                case .success: self.playerState = .playing(episode: episode)
                case .failure(let error):
                    self.playError = error
                    self.isLoadingPlay = false
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        { if self.volume < 0.1 { self.volume = 0.1 } }
    }
    
    private func set(isLoadingPlay: Bool) { self.isLoadingPlay = isLoadingPlay }
    private func set(playError: Error?) { self.playError = playError }
    
    private func player(for episode: PodcastEpisode) async throws -> PodcastPlayer {
        if let player = player, await player.episodeID == episode.id { return player }
        else {
            await self.player?.stop()
            self.observers?.forEach { $0.cancel() }
            
            let player: PodcastPlayer = episode.video != nil ?
            try await PodcastVideoPlayer(episode: episode):
            try await PodcastAudioPlayer(episode: episode)
            
            self.observers = await withTaskGroup(of: AnyCancellable.self) { tasks -> Set<AnyCancellable> in
                tasks.addTask {
                    await player.isLoadingPublisher.sink { isLoading in
                        Task { @MainActor [weak self] in self?.isLoadingPlay = isLoading }
                    }
                }
                tasks.addTask {
                    await player.errorPublisher.sink { error in
                        Task { @MainActor [weak self] in self?.playError = error }
                    }
                }
                tasks.addTask {
                    await player.elapsedTimePublisher.sink { elapsedTime in
                        Task { @MainActor [weak self] in self?.playingEpisodeElapsedTime = elapsedTime }
                    }
                }
                tasks.addTask {
                    await player.isPausedPublisher.sink { isPaused in
                        Task { @MainActor [weak self, episode] in
//                            if UIApplication.shared.applicationState == .background {
//                                Task { [weak self] in try? await self?.player?.play(episode: episode) }
//                                return
//                            }
                            if isPaused { self?.playerState = .paused(episode: episode) }
                            else { self?.playerState = .playing(episode: episode) }
                        }
                    }
                }
                tasks.addTask {
                    await player.ratePublisher.sink { rate in
                        Task { @MainActor [weak self] in self?.playingEpisodeRate = rate }
                    }
                }
                var observers = Set<AnyCancellable>()
                for await observer in tasks { observers.insert(observer) }
                return observers
            }
            
            await player.set(rate: self.playingEpisodeRate)
            await player.set(elapsedTime: self.playingEpisodeElapsedTime)
            self.player = player
            return player
        }
    }
    
    private func updateBackgroundPlayerInfos() {
        BackgroundPlayer.removeActionsTargets(to: self)
        guard let podcast = podcast, let episode = playerState.episode else { return }
        BackgroundPlayer.updateInfo(to: podcast, episode: episode, currentTime: playingEpisodeElapsedTime, playbackRate: playingEpisodeRate)
        BackgroundPlayer.addActionsTargets(to: self, playingEpisode: episode)
    }
    
    nonisolated func pause(episode: PodcastEpisode) {
        Task.detached {
            
            let result: Result<(),Error>
            do {
                try await self.player?.pause(episode: episode)
                result = .success(())
            } catch { result = .failure(error) }
            
            Task { @MainActor in
                switch result {
                case .success: self.playerState = .paused(episode: episode)
                case .failure(let error): self.playError = error
                }
            }
        }
    }
    
    func playPause(episode: PodcastEpisode) {
        guard !isLoadingPlay else { return }
        if playerState.isIdle || playerState.isPaused { play(episode: episode) }
        if playerState.isPlaying { pause(episode: episode) }
    }
    
    func stop(episode: PodcastEpisode) {
        playerState = .idle
    }
    
    nonisolated func nextTrack(after episode: PodcastEpisode) {
        
    }
    
    nonisolated func previousTrack(before episode: PodcastEpisode) {
        
    }
    
    nonisolated func changePlaybackRate(of episode: PodcastEpisode) {
        
    }
    
    nonisolated func seekForward(_ amount: Double) {
        Task { @MainActor in
            let elapsedTime = playingEpisodeElapsedTime + amount
            guard let episode = playerState.episode else { return }
            if elapsedTime >= playerState.episode?.duration ?? 0 {
                self.pause(episode: episode)
                return
            }
            await player?.set(elapsedTime: elapsedTime)
        }
    }
    
    nonisolated func seekBackward(_ amount: Double) {
        Task { @MainActor in
            let elapsedTime = playingEpisodeElapsedTime + amount
            await player?.set(elapsedTime: max(0, elapsedTime))
        }
    }
    
    func set(elapsedTime: Double) {
        if let player = player {
            Task { await player.set(elapsedTime: elapsedTime) }
        } else {
            self.playingEpisodeElapsedTime = elapsedTime
        }
    }
    
    func set(rate: Double) {
        if let player = player {
            Task { await player.set(rate: rate) }
        } else {
            self.playingEpisodeRate = rate
        }
    }
    
    
}
