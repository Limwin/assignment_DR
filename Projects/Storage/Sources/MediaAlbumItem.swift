//
//  MediaAlbumItem.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import UIKit
import MediaPlayer

public struct MediaAlbumItem {
    public let title: String
    public let artist: String
    public let artwork: UIImage?
    public let tracks: [MediaTrackItem]
}

public struct MediaTrackItem {
    public let title: String
    public let duration: TimeInterval
    public let media: MPMediaItem
}
