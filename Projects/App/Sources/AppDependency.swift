//
//  AppDependency.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import Storage
import MusicServiceInterface
import MusicServiceImplement

import MediaPlayerServiceInterface
import MediaPlayerServiceImplement

import MediaSessionServiceInterface
import MediaSessionServiceImplement

final class AppDependency {
    private let musicService: MusicService
    private let mediaService: MediaPlayerService
    private let mediaSessionService: MPMediaSessionService
    
    init() {
        let storage = MediaStorage()
        self.musicService = MusicServiceImplement(storage: storage)
        self.mediaService = MediaPlayerServiceImpl()
        self.mediaSessionService = MPMediaSessionServiceImpl()
    }
    
    func makeLibraryViewModel() -> LibraryViewModel {
        return LibraryViewModel(service: self.musicService)
    }
    
    func makeMusicPlayerState() -> MusicPlayerState {
        MusicPlayerState(mediaService: self.mediaService, mediaSessionService: mediaSessionService)
    }
}
