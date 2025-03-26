//
//  MediaStorage.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation
import MediaPlayer

public final class MediaStorage: MediaStorageType {
    
    public init() {}
    
    public func requestAuthorization() async -> Bool {
        let result = await MPMediaLibrary.requestAuthorization()
        
        switch result {
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    public func getAllMediaAlbums() async -> [MediaAlbumItem] {
        let query = MPMediaQuery.albums()
        query.groupingType = .album
        
        let albums = query.collections ?? []
        guard !albums.isEmpty else { return [] }
        
        return albums
            .compactMap { album -> MediaAlbumItem? in
                guard let representativeItem = album.representativeItem else {
                    return nil
                }
                
                let albumTitle = representativeItem.albumTitle ?? "알 수 없는 앨범"
                let albumArtist = representativeItem.albumArtist ?? "알 수 없는 아티스트"
                
                let artworkSize = representativeItem.artwork?.bounds.size ?? .zero
                let artwork = representativeItem.artwork?.image(at: artworkSize)
                
                let tracks: [MediaTrackItem] = album.items.compactMap { item -> MediaTrackItem? in
                    let trackTitle = item.title ?? "알 수 없는 곡"
                    let duration = item.playbackDuration
                    
                    return MediaTrackItem(
                        title: trackTitle,
                        duration: duration,
                        media: item
                    )
                }
                
                guard !tracks.isEmpty else { return nil }
                
                return MediaAlbumItem(
                    title: albumTitle,
                    artist: albumArtist,
                    artwork: artwork,
                    tracks: tracks
                )
            }
    }
}
