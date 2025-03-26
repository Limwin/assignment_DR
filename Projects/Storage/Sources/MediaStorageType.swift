//
//  MediaStorageType.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

public protocol MediaStorageType: AnyObject {
    func requestAuthorization() async -> Bool
    func getAllMediaAlbums() async -> [MediaAlbumItem]
}
