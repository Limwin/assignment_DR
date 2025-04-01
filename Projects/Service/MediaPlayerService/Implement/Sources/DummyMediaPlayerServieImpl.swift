//
//  DummyMediaPlayerServieImpl.swift
//  MediaPlayerService
//
//  Created by seunghyeok lim on 4/1/25.
//

import Combine

import MediaPlayer
import MediaPlayerServiceInterface

public final class DummyMediaPlayerService: MediaPlayerService {
    
    public var duration: TimeInterval = 0
    
    public init() { }
    
    public func play(mediaItem: MPMediaItem) async {}
    
    public func pause() {}
    
    public func resume() {}
    
    public func stop() {}
    
    public func seek(to time: TimeInterval) {}
    
    public var action: AnyPublisher<MediaPlayerServiceAction, Never> {
        return Empty().eraseToAnyPublisher()
    }
}
