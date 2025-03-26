//
//  Track.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation

import Storage
import MediaPlayer

public struct Track {
    public let title: String
    public let duration: TimeInterval
    public let mediaItem: MPMediaItem
    
    public init(title: String, duration: TimeInterval, mediaItem: MPMediaItem) {
        self.title = title
        self.duration = duration
        self.mediaItem = mediaItem
    }
}

extension MediaTrackItem {
    func toTrack() -> Track {
        Track(title: self.title, duration: self.duration, mediaItem: self.media)
    }
}
