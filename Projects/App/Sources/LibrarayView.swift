//
//  LibrarayView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

struct LibrarayView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Library")
            .onAppearOnce {
                self.viewModel.fetchAlbums()
            }
    }
}

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
