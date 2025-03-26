//
//  LibraryDetailView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

import CommonExtension

struct LibraryDetailView: View {
    @EnvironmentObject private var musicPlayerState: MusicPlayerState
    @ObservedObject private var viewModel: LibraryDetailViewModel
    
    init(viewModel: LibraryDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            self.headerView
            List(Array(self.viewModel.album.tracks.enumerated()), id: \.offset) { index, track in
                HStack(spacing: 12) {
                    Text("\(index + 1)")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Text(track.title)
                        .font(.system(size: 15))
                    Spacer()
                }
                .onTap {
                    self.musicPlayerState.playAlbum(
                        self.viewModel.album,
                        playMode: .trackIn(track)
                    )
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack(alignment: .top) {
                self.albumArtworkView
                VStack(alignment: .leading) {
                    Text(self.viewModel.album.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(self.viewModel.album.artistName)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            self.albumActionView
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(alignment: .bottom) {
            Rectangle()
                .fill(.white)
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 6)
        }
    }
    
    private var albumActionView: some View {
        HStack(spacing: 12) {
            ImageButton(systemName: "play.fill", size: 15, isShowBorder: true) {
                let album = self.viewModel.album
                self.musicPlayerState.playAlbum(album, playMode: .sequence)
            }
            
            
            ImageButton(systemName: "shuffle", size: 15, isShowBorder: true) {
                let album = self.viewModel.album
                self.musicPlayerState.playAlbum(album, playMode: .random)
            }
        }
    }
    
    @ViewBuilder
    private var albumArtworkView: some View {
        if let artwork = self.viewModel.album.artworkImage {
            Image(uiImage: artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(width: 100, height: 100)
        } else {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(8)
                
                Image(systemName: "music.note")
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
            }
        }
    }
}
