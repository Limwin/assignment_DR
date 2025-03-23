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
    let musicService: MusicService
    
    init() {
        let storage = AudioStorage()
        self.musicService = MusicServiceImplement(storage: storage)
    }
    
    func makeLibraryViewModel() -> LibraryViewModel {
        return LibraryViewModel(service: self.musicService)
    }
}
