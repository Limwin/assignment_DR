//
//  Track.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import CoreMedia

import MusicServiceInterface

struct Track: Hashable {
    let title: String
    let artist: String
    let duration: CMTime
}

extension MusicServiceInterface.Track {
    func toDomain() -> Track {
        Track(title: self.title, artist: self.artist, duration: self.duration)
    }
}
