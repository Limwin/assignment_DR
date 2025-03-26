//
//  MPMediaSessionService.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/26/25.
//

import UIKit
import Combine

enum MPMediaSessionServiceAction {
    case play
    case pause
    case next
    case previous
    case seek(time: TimeInterval)
}

protocol MPMediaSessionService: AnyObject {
    var action: AnyPublisher<MPMediaSessionServiceAction, Never> { get }
    
    func setup()
    func updateNowPlayingInfo(
        title: String,
        artist: String,
        albumName: String,
        artwork: UIImage?,
        duration: TimeInterval,
        currentTime: TimeInterval,
        isPlaying: Bool
    )
}

final class DummyMPMediaSessionService: MPMediaSessionService {
    func setup() { }
    
    func updateNowPlayingInfo(
        title: String,
        artist: String,
        albumName: String,
        artwork: UIImage?,
        duration: TimeInterval,
        currentTime: TimeInterval,
        isPlaying: Bool
    ) { }
    
    var action: AnyPublisher<MPMediaSessionServiceAction, Never> {
        Empty().eraseToAnyPublisher()
    }
}
