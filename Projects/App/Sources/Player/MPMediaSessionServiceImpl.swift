//
//  MPMediaSessionService.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/25/25.
//

import Combine
import MediaPlayer

final class MPMediaSessionServiceImpl: MPMediaSessionService {
    
    var action: AnyPublisher<MPMediaSessionServiceAction, Never> {
        self.actionSubject.eraseToAnyPublisher()
    }
    private let actionSubject = PassthroughSubject<MPMediaSessionServiceAction, Never>()
    
    func setup() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.nextTrackCommand.removeTarget(nil)
        commandCenter.previousTrackCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.actionSubject.send(.play)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.actionSubject.send(.pause)
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { [weak self] _ in
            self?.actionSubject.send(.next)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { [weak self] _ in
            self?.actionSubject.send(.previous)
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let positionEvent = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            
            self?.actionSubject.send(.seek(time: positionEvent.positionTime))
            return .success
        }
    }
    
    func updateNowPlayingInfo(
        title: String,
        artist: String,
        albumName: String,
        artwork: UIImage?,
        duration: TimeInterval,
        currentTime: TimeInterval,
        isPlaying: Bool
    ) {
        var nowPlayingInfo = [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = albumName
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        if let artwork {
            let mpArtwork = MPMediaItemArtwork(boundsSize: artwork.size) { _ in artwork }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = mpArtwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
