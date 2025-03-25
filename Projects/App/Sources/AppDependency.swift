//
//  AppDependency.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import Storage
import MusicServiceInterface
import MusicServiceImplement

final class AppDependency {
    private let musicService: MusicService
    private let audioService: AVAudioPlayerService
    
    init() {
        let storage = AudioStorage()
        self.musicService = MusicServiceImplement(storage: storage)
        self.audioService = AVAudioPlayerService()
    }
    
    func makeLibraryViewModel() -> LibraryViewModel {
        return LibraryViewModel(service: self.musicService)
    }
    
    func makeMusicPlayerState() -> MusicPlayerState {
        MusicPlayerState(audioService: self.audioService)
    }
}
