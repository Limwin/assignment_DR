//
//  DummyMediaSessionServiceImpl.swift
//  MediaSessionService
//
//  Created by seunghyeok lim on 4/1/25.
//

import UIKit
import Combine

import MediaSessionServiceInterface

public final class DummyMPMediaSessionService: MPMediaSessionService {
    
    public init() { }
    public func setup() { }
    
    public func updateNowPlayingInfo(
        title: String,
        artist: String,
        albumName: String,
        artwork: UIImage?,
        duration: TimeInterval,
        currentTime: TimeInterval,
        isPlaying: Bool
    ) { }
    
    public var action: AnyPublisher<MPMediaSessionServiceAction, Never> {
        Empty().eraseToAnyPublisher()
    }
}
