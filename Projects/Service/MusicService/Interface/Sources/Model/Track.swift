//
//  Track.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import CoreMedia

public struct Track {
    public let title: String
    public let artist: String
    public let duration: CMTime
    
    public init(title: String, artist: String, duration: CMTime) {
        self.title = title
        self.artist = artist
        self.duration = duration
    }
}
