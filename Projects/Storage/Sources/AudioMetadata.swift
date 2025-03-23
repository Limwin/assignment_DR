//
//  AudioMetadata.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation
import AVFoundation

public struct AudioMetadata {
    public let albumName: String
    public let title: String
    public let artist: String
    public let artworkData: Data?
    public let duration: CMTime
}
