//
//  LibrarayView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

import MusicServiceImplement

struct LibrarayView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: self.columns, spacing: 20) {
                    ForEach(self.viewModel.albums, id: \.name) { album in
                        LibraryCell(album: album)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("음악 라이브러리")
            .background(Color(.systemGroupedBackground))
            .onAppearOnce {
                self.viewModel.fetchAlbums()
            }
        }
    }
}

#Preview {
    let stubService = StubMusicService()
    let viewModel = LibraryViewModel(service: stubService)
    LibrarayView(viewModel: viewModel)
}
