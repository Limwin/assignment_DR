//
//  StubMusicService.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation
import MusicServiceInterface

public final class StubMusicService: MusicService {
    public init() {}
    
    public func fetchAlbums() async throws -> [Album] {
        return [
            Album(title: "앨범명1", artistName: "아티스트1", artwork: nil, tracks: [
                Track(title: "트랙1", duration: 30, mediaItem: .init()),
            ]),
            Album(title: "앨범명2", artistName: "아티스트2", artwork: nil, tracks: [
                Track(title: "트랙2", duration: 30, mediaItem: .init()),
            ]),
        ]
    }
}
