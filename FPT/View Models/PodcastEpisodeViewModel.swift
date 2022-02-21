//
//  PodcastEpisodeViewModel.swift
//  FPT
//
//  Created by Hans Rietmann on 14/02/2022.
//

import SwiftUI
import YouTubePlayerKit
import AVFoundation
import MediaPlayer
import Combine



@MainActor
class PodcastEpisodeViewModel: ObservableObject {
    
    
    // MARK: - Play States -
    let episode: PodcastEpisode
//    @Published private(set) var isLoadingPlay = false
//    @Published private(set) var playError: Error?
//    enum PlayerState: Equatable {
//        
//        case idle
//        case playing(PodcastPlayer)
//        case paused(PodcastPlayer)
//        
//        var isIdle: Bool {
//            switch self {
//            case .idle: return true
//            default: return false
//            }
//        }
//        var isPlaying: Bool {
//            switch self {
//            case .playing: return true
//            default: return false
//            }
//        }
//        var isPaused: Bool {
//            switch self {
//            case .paused: return true
//            default: return false
//            }
//        }
//        var player: PodcastPlayer? {
//            switch self {
//            case .playing(let player): return player
//            case .paused(let player): return player
//            default: return nil
//            }
//        }
//        var videoPlayer: PodcastVideoPlayer? { player as? PodcastVideoPlayer }
//        var audioPlayer: PodcastAudioPlayer? { player as? PodcastAudioPlayer }
//        
//        static func ==(lhs: Self, rhs: Self) -> Bool {
//            if lhs.isIdle, rhs.isIdle { return true }
//            if lhs.player?.id == rhs.player?.id { return lhs.isPlaying == rhs.isPlaying }
//            return false
//        }
//    }
//    @Published private(set) var state = PlayerState.idle
    
    
    // MARK: - Controls properties -
    @Published var rate: Double = 1
    @Published var elapsedTime: Double = 0
    var timeLeft: Double { (episode.duration ?? 0) - elapsedTime }
    
    
//    private var observers: Set<AnyCancellable>?
    
    
    init(episode: PodcastEpisode) {
        self.episode = episode
    }
    
//    deinit { observers?.forEach { $0.cancel() } }
    
    
//    func play(on podcast: PodcastViewModel) {
//        guard !isLoadingPlay else { return }
//        podcast.play(episode: episode)
//        playError = nil
//        if let player = state.player, state.isPaused {
//            Task.detached { await player.play() }
//        }
//        if state.isIdle {
//
//            // Create play session
//            Task.detached {
//
//                let player: PodcastPlayer
//                do {
//                    if let video = self.episode.video {
//                        player = await PodcastVideoPlayer(video: video, elapsedTime: self.elapsedTime)
//                    } else if let audioURL = self.episode.audioURL {
//                        player = try await PodcastAudioPlayer(url: audioURL)
//                    } else { throw FPTError(custom: "Ooops! No audio file found either a video episode… 🤭") }
//                } catch {
//                    Task { @MainActor [weak self] in self?.playError = error }
//                    return
//                }
//
//                let isLoadingObserver = await player.isLoadingPublisher.sink { isLoading in
//                    Task { @MainActor [weak self] in self?.isLoadingPlay = isLoading }
//                }
//                let errorObserver = await player.errorPublisher.sink { error in
//                    Task { @MainActor [weak self] in self?.playError = error }
//                }
//                let elapsedTimeObserver = await player.elapsedTimePublisher.sink { elapsedTime in
//                    Task { @MainActor [weak self] in self?.elapsedTime = elapsedTime }
//                }
//                let isPausedObserver = await player.isPausedPublisher.sink { isPaused in
//                    Task { @MainActor [weak self, player] in
//                        if isPaused { self?.state = .paused(player) }
//                        else { self?.state = .playing(player) }
//                    }
//                }
//                let rateObserver = await player.ratePublisher.sink { rate in
//                    Task { @MainActor [weak self] in self?.rate = rate }
//                }
//                Task { @MainActor [weak self] in
//                    await player.play()
//                    guard let self = self else { return }
//                    await player.set(rate: self.rate)
//                    await player.set(elapsedTime: self.elapsedTime)
//                    self.observers = [isLoadingObserver, errorObserver, elapsedTimeObserver, isPausedObserver, rateObserver]
//                }
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
//            { if self.volume < 0.2 { self.volume = 0.2 } }
//        }
//    }
    
//    func set(elapsedTime: Double) {
//        if let player = state.player {
//            Task { await player.set(elapsedTime: elapsedTime) }
//        } else {
//            self.elapsedTime = elapsedTime
//        }
//    }
    
//    func set(rate: Double) {
//        if let player = state.player {
//            Task { await player.set(rate: rate) }
//        } else {
//            self.rate = rate
//        }
//    }
    
//    func pause(on podcast: PodcastViewModel) {
//        guard !isLoadingPlay else { return }
//        if let player = state.player, state.isPlaying {
//            podcast.pause(episode: episode)
//            Task.detached { await player.pause() }
//        }
//    }
    
//    func playPause(on podcast: PodcastViewModel) {
//        guard !isLoadingPlay else { return }
//        if state.isIdle || state.isPaused { play(on: podcast) }
//        if state.isPlaying { pause(on: podcast) }
//    }
    
//    func extendVideo() {
//        Task { await state.videoPlayer?.extendFullScreen() }
//    }
    
    
}

