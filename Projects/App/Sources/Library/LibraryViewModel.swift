//
//  LibraryViewModel.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation

import MusicServiceInterface

final class LibraryViewModel: ObservableObject {
    
    @Published private(set) var albums: [Album] = []
    private let service: MusicService
    
    init(service: MusicService) {
        self.service = service
    }
    
    @MainActor
    func fetchAlbums() {
        Task {
            do {
                let albums = try await self.service.fetchAlbums().map { $0.toDomain() }
                
                self.albums.append(contentsOf: albums)
            } catch {
                
            }
        }
    }
    
    func makeDetailViewModel(for album: Album) -> LibraryDetailViewModel {
        LibraryDetailViewModel(album: album)
    }
}
