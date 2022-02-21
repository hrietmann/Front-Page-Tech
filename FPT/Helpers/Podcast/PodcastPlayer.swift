//
//  PodcastPlayer.swift
//  FPT
//
//  Created by Hans Rietmann on 14/02/2022.
//

import Foundation



protocol PodcastPlayer: Actor {
    
    
    nonisolated var id: UUID { get }
    
    var episodeID: String { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    var isPausedPublisher: Published<Bool>.Publisher { get }
    var elapsedTimePublisher: Published<Double>.Publisher { get }
    var ratePublisher: Published<Double>.Publisher { get }
    
    init(episode: PodcastEpisode) async throws
    
    func play(episode: PodcastEpisode) throws
    func pause(episode: PodcastEpisode) throws
    func stop()
    func set(elapsedTime: Double)
    func set(rate: Double)
    
}
