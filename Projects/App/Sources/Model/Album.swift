//
//  Album.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import UIKit

import MusicServiceInterface

struct Album: Hashable {
    let name: String
    let artistName: String
    let artworkImage: UIImage?
    let tracks: [Track]
}

extension MusicServiceInterface.Album {
    func toDomain() -> Album {
        Album(
            name: self.title,
            artistName: self.artistName,
            artworkImage: self.artwork,
            tracks: self.tracks.map { $0.toDomain() }
        )
    }
}
