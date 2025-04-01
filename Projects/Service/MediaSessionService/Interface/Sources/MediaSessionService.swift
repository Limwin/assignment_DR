//
//  MediaSessionService.swift
//  MediaSessionService
//
//  Created by seunghyeok lim on 4/1/25.
//

import UIKit
import Combine

public enum MPMediaSessionServiceAction {
    case play
    case pause
    case next
    case previous
}

public protocol MPMediaSessionService: AnyObject {
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
