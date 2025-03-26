//
//  StubMediaStorage.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

import UIKit

final class StubMediaStorage: MediaStorageType {
    func requestAuthorization() async -> Bool {
        true
    }
    
    func getAllMediaAlbums() async -> [MediaAlbumItem] {
        let item = MediaAlbumItem(
            title: "Album Title",
            artist: "Artist Name",
            artwork: UIImage(),
            tracks: []
        )
        
        return [item]
    }
}
