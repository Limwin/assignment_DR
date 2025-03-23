//
//  AudioStorageType.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

public protocol AudioStorageType: AnyObject {
    func getAllAudioMetadata() async -> [AudioMetadata]
}
