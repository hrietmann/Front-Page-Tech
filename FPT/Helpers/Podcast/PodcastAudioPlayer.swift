//
//  PodcastAudioPlayer.swift
//  FPT
//
//  Created by Hans Rietmann on 14/02/2022.
//

import Foundation
import Combine
import AVFoundation



actor PodcastAudioPlayer: PodcastPlayer {
    
    let id = UUID()
    let player: AVPlayer
    private(set) var episodeID: String
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var isPaused = true
    private var elapsedTimeFromPlayerObserver = false
    @Published private(set) var elapsedTime: Double = 0
    @Published private(set) var rate: Double = 1
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    var isPausedPublisher: Published<Bool>.Publisher { $isPaused }
    var elapsedTimePublisher: Published<Double>.Publisher { $elapsedTime }
    var ratePublisher: Published<Double>.Publisher { $rate }
    
    private var timeObserver: Any?
    private var prerollObserver: NSKeyValueObservation?
    private var errorObserver: NSKeyValueObservation?
    
    
    init(episode: PodcastEpisode) async throws {
        episodeID = episode.id
        guard let url = episode.audioURL else { throw FPTError(custom: "No audio file found.") }
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        
        let asset = AVAsset(url: url)
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        player = AVPlayer(playerItem: item)
        player.audiovisualBackgroundPlaybackPolicy = .continuesIfPossible
        setObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func setObservers() {
        guard let item = player.currentItem else { return }
        errorObserver = item.observe(\.error, options:  [.new, .old]) { (playerItem, change) in
            self.error = change.newValue as? Error
        }
        prerollObserver = item.observe(\.status, options:  [.new, .old]) { (playerItem, change) in
//            self.isLoading = false
        }
        timeObserver = player.addPeriodicTimeObserver(forInterval: .init(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            self.elapsedTime = time.seconds
            guard self.isLoading else { return }
            self.isLoading = false
        }
    }
    
    private func removeObservers() {
        Task { @MainActor in player.pause() }
        prerollObserver?.invalidate()
        errorObserver?.invalidate()
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }
    
    func play(episode: PodcastEpisode) throws {
        isLoading = true
        error = nil
        if episodeID == episode.id {
            Task { await player.play() ; self.isPaused = false }
            return
        }
        
        guard let url = episode.audioURL else { throw FPTError(custom: "No audio file found.") }
        removeObservers()
        let asset = AVAsset(url: url)
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        let item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        player.replaceCurrentItem(with: item)
        episodeID = episode.id
        setObservers()
    }
    
    func pause(episode: PodcastEpisode) throws {
        guard episode.id == episodeID else { return }
        Task { await player.pause() ; self.isPaused = true }
    }
    
    func stop() {
        Task { await player.pause() ; self.isPaused = true }
    }
    
    func set(elapsedTime: Double) {
        isLoading = true
        Task { @MainActor in player.seek(to: CMTime(seconds: elapsedTime, preferredTimescale: 1)) }
    }
    
    func set(rate: Double) {
        Task { @MainActor in player.rate = Float(rate) }
    }
    
    static func ==(lhs: PodcastAudioPlayer, rhs: PodcastAudioPlayer) -> Bool { lhs.id == rhs.id }
}
