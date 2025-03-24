//
//  LibraryView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

import MusicServiceImplement

struct LibraryView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                self.contentView
                    .navigationTitle("음악 라이브러리")
                    .background(Color(.systemGroupedBackground))
                    .onAppearOnce {
                        self.viewModel.fetchAlbums()
                    }
            }
            
            self.playerView
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVGrid(columns: self.columns, spacing: 20) {
                ForEach(self.viewModel.albums, id: \.self) { album in
                    NavigationLink(
                        destination: {
                            LibraryDetailView(
                                viewModel: self.viewModel.makeDetailViewModel(for: album)
                            )
                        }) {
                            LibraryCell(album: album)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var playerView: some View {
        MusicPlayerView()
            .background(.white)
            .transition(.move(edge: .bottom))
    }
}

#Preview {
    let stubService = StubMusicService()
    let viewModel = LibraryViewModel(service: stubService)
    LibraryView(viewModel: viewModel)
}
