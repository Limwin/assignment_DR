//
//  StorageHandler.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation
import AVFoundation

public final class StorageHandler {
    
    public init() {}
    
    private var bundle: Bundle {
        Bundle(for: StorageHandler.self)
    }
    
    public func getAllAlbums() async -> [AssetInfo] {
        guard let resourcePath = self.bundle.resourcePath else { return [] }
        
        let bundleURL = URL(fileURLWithPath: resourcePath)
        
        do {
            let mp3FileURLs = try FileManager.default.contentsOfDirectory(
                at: bundleURL,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            .filter { $0.pathExtension == "mp3" }

            var assetInfos: [AssetInfo] = []
            for url in mp3FileURLs {
                let assetInfo = try await self.loadAssetInfo(from: url)
                assetInfos.append(assetInfo)
            }
            
            return assetInfos
        } catch {
            return []
        }
    }
    
    private func loadAssetInfo(from audioURL: URL) async throws -> AssetInfo {
        let asset = AVURLAsset(url: audioURL)
        
        let metadataItems = try await asset.load(.metadata)
        let duration = try await asset.load(.duration)
        
        return AssetInfo(items: metadataItems, duration: duration)
    }
}
