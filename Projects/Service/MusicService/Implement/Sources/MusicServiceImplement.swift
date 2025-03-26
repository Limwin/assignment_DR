//
//  MusicServiceImplement.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import MusicServiceInterface
import Storage

public final class MusicServiceImplement: MusicService {
    private let storage: MediaStorageType
    
    public init(storage: MediaStorageType) {
        self.storage = storage
    }
    
    public func fetchAlbums() async throws -> [Album] {
        guard await self.storage.requestAuthorization() else { return [] }
        let mediaAlbums = await self.storage.getAllMediaAlbums()
        
        return mediaAlbums.map { $0.toAlbum() }
    }
}
