//
//  BackgroundPlayer.swift
//  FPT
//
//  Created by Hans Rietmann on 12/02/2022.
//

import MediaPlayer


protocol BackgroundPlayerManager {
    
    func play(episode: PodcastEpisode)
    func pause(episode: PodcastEpisode)
    func nextTrack(after episode: PodcastEpisode)
    func previousTrack(before episode: PodcastEpisode)
    func seekBackward(_ amount: Double)
    func seekForward(_ amount: Double)
    func changePlaybackRate(of episode: PodcastEpisode)
    
}


struct BackgroundPlayer {
    
    private let episode: PodcastEpisode
    private let podcast: Podcast
    private let currentTime: Double
    private let playbackRate: Double
    
    private var title: String { episode.title ?? "Title" }
    private var albumTitle: String {
        guard let count = episode.number else { return "Special Episode" }
        return "Episode #\(count)"
    }
    private var artist: String { podcast.name }
    private var genre: String { podcast.genre }
    private var duration: Double { (episode.duration ?? 0) - currentTime }
    
    static func addActionsTargets(to manager: BackgroundPlayerManager, playingEpisode: PodcastEpisode) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        MPRemoteCommandCenter.shared().playCommand.isEnabled = true
        MPRemoteCommandCenter.shared().pauseCommand.isEnabled = true
        MPRemoteCommandCenter.shared().changePlaybackRateCommand.isEnabled = false
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.isEnabled = true
        
        MPRemoteCommandCenter.shared().nextTrackCommand.isEnabled = false
        MPRemoteCommandCenter.shared().previousTrackCommand.isEnabled = false
        
        MPRemoteCommandCenter.shared().skipBackwardCommand.isEnabled = true
        MPRemoteCommandCenter.shared().skipForwardCommand.isEnabled = true
        
        MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [.init(value: 15)]
        MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [.init(value: 15)]
        
        MPRemoteCommandCenter.shared().seekForwardCommand.isEnabled = false
        MPRemoteCommandCenter.shared().seekBackwardCommand.isEnabled = false
        
        MPRemoteCommandCenter.shared().playCommand.addTarget
        { _ in Task { @MainActor in manager.play(episode: playingEpisode) } ; return .success }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget
        { _ in Task { @MainActor in manager.pause(episode: playingEpisode) } ; return .success }
        
//        MPRemoteCommandCenter.shared().changePlaybackRateCommand.addTarget
//        { _ in Task { @MainActor in manager.changePlaybackRate(of: playingEpisode) } ; return .success }
        
//        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget
//        { _ in Task { @MainActor in manager.nextTrack(after: playingEpisode) } ; return .success }
//
//        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget
//        { event in Task { @MainActor in manager.previousTrack(before: playingEpisode) } ; return .success }
        
        MPRemoteCommandCenter.shared().skipBackwardCommand.addTarget
        { _ in Task { @MainActor in manager.seekBackward(15) } ; return .success }

        MPRemoteCommandCenter.shared().skipForwardCommand.addTarget
        { _ in Task { @MainActor in manager.seekForward(15) } ; return .success }
        
//        MPRemoteCommandCenter.shared().seekBackwardCommand.addTarget
//        { _ in Task { @MainActor in manager.seekBackward(15) } ; return .success }
//
//        MPRemoteCommandCenter.shared().seekForwardCommand.addTarget
//        { _ in Task { @MainActor in manager.seekForward(15) } ; return .success }
    }
    
    static func removeActionsTargets(to manager: BackgroundPlayerManager) {
        UIApplication.shared.endReceivingRemoteControlEvents()
        MPRemoteCommandCenter.shared().playCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().pauseCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().previousTrackCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().changePlaybackRateCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().seekBackwardCommand.removeTarget(manager)
        MPRemoteCommandCenter.shared().seekForwardCommand.removeTarget(manager)
    }
    
    static func updateInfo(to podcast: Podcast, episode: PodcastEpisode, currentTime: Double, playbackRate: Double) {
        let info = BackgroundPlayer(episode: episode, podcast: podcast, currentTime: currentTime, playbackRate: playbackRate)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyAlbumTitle: info.albumTitle,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyGenre: info.genre,
            MPMediaItemPropertyPlaybackDuration: info.duration,
            MPMediaItemPropertyMediaType: "Podcast",
            MPNowPlayingInfoPropertyPlaybackRate: info.playbackRate,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: info.currentTime,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: .greatestFiniteSize) { _ in info.podcast.artwork }
        ]
    }
}
