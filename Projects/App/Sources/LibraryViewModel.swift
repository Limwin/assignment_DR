//
//  LibraryViewModel.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation

import MusicServiceInterface

final class LibraryViewModel: ObservableObject {
    
    private let service: MusicService
    
    init(service: MusicService) {
        self.service = service
    }
    
    func fetchAlbums() {
        Task.detached {
            try? await self.service.fetchAlbums()
        }
    }
}
