//
//  PodcastVideoPlayer.swift
//  FPT
//
//  Created by Hans Rietmann on 14/02/2022.
//

import Foundation
import Combine
import YouTubePlayerKit




actor PodcastVideoPlayer: PodcastPlayer {
    
    let id = UUID()
    let player: YouTubePlayer
    private(set) var episodeID: String
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    @Published private(set) var isPaused = true
    private var elapsedTimeFromPlayerObserver = false
    @Published private(set) var elapsedTime: Double = 0
//    {
//        willSet {
//            guard newValue != elapsedTime else { return }
//            guard !elapsedTimeFromPlayerObserver
//            else { elapsedTimeFromPlayerObserver = false; return }
//            Task { @MainActor in player.seek(to: newValue, allowSeekAhead: true) }
//        }
//    }
    @Published private(set) var rate: Double = 1
//    {
//        willSet {
//            guard newValue != rate else { return }
//            Task { @MainActor in player.set(playbackRate: newValue) }
//        }
//    }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    var isPausedPublisher: Published<Bool>.Publisher { $isPaused }
    var elapsedTimePublisher: Published<Double>.Publisher { $elapsedTime }
    var ratePublisher: Published<Double>.Publisher { $rate }
    
    private var playbackStateObersver: AnyCancellable?
    private var stateObserver: AnyCancellable?
    private var elapsedTimeObserver: AnyCancellable?
    private var rateObserver: AnyCancellable?
    
    
    init(episode: PodcastEpisode) async throws {
        episodeID = episode.id
        guard let video = episode.video else { throw FPTError(custom: "No video found") }
        
        let source = YouTubePlayer.Source.video(id: video.videoID)
        let configuration = YouTubePlayer.Configuration(
            isUserInteractionEnabled: false,
            allowsPictureInPictureMediaPlayback: true,
            autoPlay: true,
            captionLanguage: nil,
            showCaptions: false,
            progressBarColor: .none,
            showControls: false,
            keyboardControlsDisabled: true,
            enableJavaScriptAPI: true,
            endTime: nil,
            showFullscreenButton: false,
            language: nil,
            showAnnotations: false,
            loopEnabled: false,
            useModestBranding: false,
            playInline: false,
            showRelatedVideos: false,
            startTime: 0,
            referrer: nil,
            customUserAgent: nil)
        player = YouTubePlayer(source: source, configuration: configuration)
        setObservers()
    }
    
    deinit {
        removeObserver()
    }
    
    private func setObservers() {
        stateObserver = player.statePublisher.sink { state in
            switch state {
            case .error(let error): self.error = error
            default: break
            }
        }
        playbackStateObersver = player.playbackStatePublisher.sink { state in
            switch state {
            case .cued: self.isLoading = true
            case .paused, .unstarted, .ended: self.isPaused = true
            case .playing: self.isPaused = false
            default: break
            }
        }
        rateObserver = player.playbackRatePublisher.sink { rate in
            guard self.rate != rate else { return }
            self.rate = rate
        }
        elapsedTimeObserver = player.currentTimePublisher(updateInterval: 1).sink { currentTime in
            self.elapsedTimeFromPlayerObserver = true
            self.elapsedTime = currentTime
            guard self.isLoading else { return }
            self.isLoading = false
        }
    }
    
    private func removeObserver() {
        player.stop()
        playbackStateObersver?.cancel()
        stateObserver?.cancel()
        elapsedTimeObserver?.cancel()
        rateObserver?.cancel()
    }
    
    func play(episode: PodcastEpisode) throws {
        isLoading = true
        error = nil
        if episode.id == episodeID {
            Task { @MainActor in player.play() }
            return
        }
        
        guard let video = episode.video else { throw FPTError(custom: "No video found") }
        episodeID = episode.id
        player.source = YouTubePlayer.Source.video(id: video.videoID)
    }
    
    func pause(episode: PodcastEpisode) throws {
        guard episode.id == episodeID else { return }
        Task { @MainActor in player.pause() }
    }
    
    func stop() {
        player.stop()
    }
    
    func set(elapsedTime: Double) {
        isLoading = true
        Task { @MainActor in player.seek(to: elapsedTime, allowSeekAhead: true) }
    }
    
    func set(rate: Double) {
        Task { @MainActor in player.set(playbackRate: rate) }
    }
    
    func extendFullScreen() {
        
    }
    
    static func ==(lhs: PodcastVideoPlayer, rhs: PodcastVideoPlayer) -> Bool { lhs.id == rhs.id }
}
