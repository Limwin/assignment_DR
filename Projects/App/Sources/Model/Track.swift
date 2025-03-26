//
//  Track.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import CoreMedia

import MusicServiceInterface
import MediaPlayer

struct Track: Hashable {
    let title: String
    let duration: TimeInterval
    let mediaItem: MPMediaItem
}

extension MusicServiceInterface.Track {
    func toDomain() -> Track {
        Track(title: self.title, duration: self.duration, mediaItem: self.mediaItem)
    }
}
