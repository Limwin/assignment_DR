//
//  Album.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation

public struct Album {
    public let name: String
    public let artwork: Data?
    public let tracks: [Track]
    
    public init(name: String, artwork: Data?, tracks: [Track]) {
        self.name = name
        self.artwork = artwork
        self.tracks = tracks
    }
}
