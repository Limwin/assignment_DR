//
//  StubAudioStorage.swift
//  Storage
//
//  Created by seunghyeok lim on 3/23/25.
//

final class StubAudioStorage: AudioStorageType {
    func getAllAudioMetadata() async -> [AudioMetadata] {
        let data = AudioMetadata(
            albumName: "테스트 앨범",
            title: "테스트 제목",
            artist: "아티스트 명",
            artworkData: nil,
            duration: .zero
        )
        
        return [data]
    }
}
