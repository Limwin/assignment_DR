//
//  AudioStorage.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation
import AVFoundation

public final class AudioStorage: AudioStorageType {
    
    private var bundle: Bundle {
        Bundle(for: AudioStorage.self)
    }
    
    public init() {}
    
    public func getAllAudioMetadata() async -> [AudioMetadata] {
        guard let resourcePath = self.bundle.resourcePath else { return [] }
        
        let bundleURL = URL(fileURLWithPath: resourcePath)
        
        do {
            let mp3FileURLs = try FileManager.default.contentsOfDirectory(
                at: bundleURL,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            .filter { $0.pathExtension == "mp3" }

            var assetInfos: [AudioMetadata] = []
            for url in mp3FileURLs {
                let assetInfo = try await self.loadAssetInfo(from: url)
                assetInfos.append(assetInfo)
            }
            
            return assetInfos
        } catch {
            return []
        }
    }
    
    private func loadAssetInfo(from audioURL: URL) async throws -> AudioMetadata {
        let asset = AVURLAsset(url: audioURL)
        
        let metadataItems = try await asset.load(.commonMetadata)
        let duration = try await asset.load(.duration)
        
        let albumName = try await self.loadStringValue(
            from: metadataItems,
            identifier: .commonIdentifierAlbumName
        ) ?? ""
        let artist = try await self.loadStringValue(
            from: metadataItems,
            identifier: .commonIdentifierArtist
        ) ?? ""
        let title = try await self.loadStringValue(
            from: metadataItems,
            identifier: .commonIdentifierTitle
        ) ?? ""
        let artwork = try await self.loadDataValue(
            from: metadataItems,
            identifier: .commonIdentifierArtwork
        )
        
        return AudioMetadata(
            albumName: albumName,
            title: title,
            artist: artist,
            artworkData: artwork,
            duration: duration,
            url: audioURL
        )
    }
    
    private func loadStringValue(
        from metadataItems: [AVMetadataItem],
        identifier: AVMetadataIdentifier
    ) async throws -> String? {
        let item = AVMetadataItem.metadataItems(
            from: metadataItems,
            filteredByIdentifier: identifier
        ).first
        
        return try await item?.load(.stringValue)
    }
    
    private func loadDataValue(
        from metadataItems: [AVMetadataItem],
        identifier: AVMetadataIdentifier
    ) async throws -> Data? {
        let item = AVMetadataItem.metadataItems(
            from: metadataItems,
            filteredByIdentifier: identifier
        ).first
        
        return try await item?.load(.dataValue)
    }
}
