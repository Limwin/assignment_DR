//
//  StubMusicService.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import MusicServiceInterface

public final class StubMusicService: MusicService {
    public init() {}
    
    public func fetchAlbums() async throws -> [Album] {
        return [
            Album(
                name: "앨범명1",
                artwork: nil,
                tracks: [
                    Track(title: "트랙 1", artist: "아티스트명", duration: .zero),
                    Track(title: "트랙 2", artist: "아티스트명", duration: .zero),
                ]
            ),
            Album(
                name: "앨범명2",
                artwork: nil,
                tracks: [
                    Track(title: "트랙 1", artist: "아티스트명1", duration: .zero),
                    Track(title: "트랙 2", artist: "아티스트명2", duration: .zero),
                ]
            )
        ]
    }
}
