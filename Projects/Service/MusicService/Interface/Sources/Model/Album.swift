//
//  Album.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import UIKit

import Storage

public struct Album {
    public let title: String
    public let artistName: String
    public let artwork: UIImage?
    public let tracks: [Track]
    
    public init(title: String, artistName: String, artwork: UIImage?, tracks: [Track]) {
        self.title = title
        self.artistName = artistName
        self.artwork = artwork
        self.tracks = tracks
    }
}

extension MediaAlbumItem {
    public func toAlbum() -> Album {
        Album(
            title: self.title,
            artistName: self.artist,
            artwork: self.artwork,
            tracks: self.tracks.map { $0.toTrack() }
        )
    }
}
