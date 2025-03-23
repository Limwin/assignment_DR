//
//  Album.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import UIKit

import MusicServiceInterface

struct Album {
    let name: String
    let artworkImage: UIImage?
    let tracks: [Track]
    
    var artistName: String {
        self.tracks.first?.artist ?? ""
    }
}

extension MusicServiceInterface.Album {
    func toDomain() -> Album {
        let artworkImage: UIImage? = if let artwork {
            UIImage(data: artwork)
        } else {
            nil
        }
        
        return Album(
            name: self.name,
            artworkImage: artworkImage,
            tracks: tracks.map {
                $0.toDomain()
            }
        )
    }
}
