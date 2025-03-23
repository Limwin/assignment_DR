//
//  MusicService.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

public protocol MusicService: AnyObject {
    func fetchAlbums() async throws -> [Album]
}
