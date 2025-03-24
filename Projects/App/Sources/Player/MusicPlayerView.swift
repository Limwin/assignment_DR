//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/24/25.
//

import SwiftUI
import CommonExtension

struct MusicPlayerView: View {
    @EnvironmentObject private var playerState: MusicPlayerState
    
    var body: some View {
        VStack {
            if self.playerState.showMiniPlayer {
                self.progressBarView
                self.contentView
            } else {
                EmptyView()
            }
        }
    }
    
    private var progressBarView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 3)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(
                        width: self.playerState.progressWidth(totalWidth: geometry.size.width),
                        height: 3
                    )
            }
        }
        .frame(height: 3)
    }
    
    private var contentView: some View {
        HStack {
            self.playpauseButton
                .foregroundStyle(.black)
                .onTap {
                    self.playerState.togglePlay()
                }
            
            Spacer()
            
            self.trackInfoView
            
            Spacer()
            
            self.artworkView
        }.padding(16)
    }
    
    @ViewBuilder
    private var playpauseButton: some View {
        if self.playerState.isPlaying {
            Image(systemName: "pause.fill")
                .resizable()
                .frame(size: 24)
        } else {
            Image(systemName: "play.fill")
                .resizable()
                .frame(size: 24)
        }
    }
    
    private var trackInfoView: some View {
        VStack {
            Text(self.playerState.albumName)
                .font(.system(size: 16, weight: .semibold))
            Text(self.playerState.trackNameWithArtist)
                .font(.system(size: 13))
        }
    }
    
    @ViewBuilder
    private var artworkView: some View {
        if let artwork = self.playerState.artworkImage {
            Image(uiImage: artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .frame(size: 44)
        }
    }
}
