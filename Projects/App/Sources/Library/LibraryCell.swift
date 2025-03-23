//
//  LibraryCell.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

struct LibraryCell: View {
    private let album: Album
    
    init(album: Album) {
        self.album = album
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            self.albumArtworkView
            self.albumInfoView
        }
    }
    
    @ViewBuilder
    private var albumArtworkView: some View {
        if let artwork = self.album.artworkImage {
            Image(uiImage: artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
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
    
    private var albumInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.album.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(self.album.artistName)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
    }
}
