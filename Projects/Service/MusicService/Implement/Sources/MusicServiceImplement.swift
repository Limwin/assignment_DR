//
//  MusicServiceImplement.swift
//  MusicService
//
//  Created by seunghyeok lim on 3/23/25.
//

import AVFoundation

import MusicServiceInterface
import Storage

public final class MusicServiceImplement: MusicService {
    
    private let storage: AudioStorageType
    
    public init(storage: AudioStorageType) {
        self.storage = storage
    }
    
    public func fetchAlbums() async throws -> [Album] {
        let metadataList = await self.storage.getAllAudioMetadata()
        let trackInfos = self.makeTracks(from: metadataList)
        let albums = self.makeAlbums(from: trackInfos)
        
        return albums
    }
    
    private func makeTracks(from metadataList: [AudioMetadata]) -> [TrackInfo] {
        metadataList.map { metadata in
            let track = Track(
                title: metadata.title,
                artist: metadata.artist,
                duration: metadata.duration,
                url: metadata.url
            )
            
            return TrackInfo(
                albumName: metadata.albumName,
                track: track,
                artwork: metadata.artworkData
            )
        }
    }
    
    private func makeAlbums(from trackInfos: [TrackInfo]) -> [Album] {
        let albumDictionary = Dictionary(grouping: trackInfos, by: { $0.albumName })
        return albumDictionary
            .map { albumName, infos in
            let tracks = infos.map { $0.track }
            let artwork = infos.compactMap { $0.artwork }.first
            
            return Album(
                name: albumName,
                artwork: artwork,
                tracks: tracks
            )
        }.sorted(by: { $0.name < $1.name })
    }
}
