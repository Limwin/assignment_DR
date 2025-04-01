//
//  MusicPlayerView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/24/25.
//

import SwiftUI
import CommonExtension

import MediaPlayerServiceImplement
import MediaSessionServiceImplement

struct MusicPlayerView: View {
    @EnvironmentObject private var playerState: MusicPlayerState
    @State private var isExpanded = false
    @State private var volume: Float = 0.3
    
    var body: some View {
        ZStack(alignment: .bottom) {
            self.dimmedView
            
            VStack {
                if self.isExpanded {
                    self.expandedPlayerView
                } else {
                    self.miniPlayerView
                }
            }
        }
        .animation(.easeInOut, value: self.isExpanded)
        .isHidden(!self.playerState.showMiniPlayer)
    }
    
    @ViewBuilder
    private var dimmedView: some View {
        if self.isExpanded {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        self.isExpanded = false
                    }
                }
                .transition(.opacity)
        }
    }
    
    private var miniPlayerView: some View {
        VStack {
            self.progressBarView
            HStack {
                self.playpauseButton
                
                Spacer()
                
                self.trackInfoView
                
                Spacer()
                
                AlbumImageView(cornerRadius: 12, size: 50, content: { self.artworkView })
            }
            .padding(20)
            .compositingGroup()
            .onTapGesture {
                self.isExpanded = true
            }
        }
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.bottom)
        )
    }
    
    private var expandedPlayerView: some View {
        VStack(spacing: 32) {
            HStack {
                Spacer()
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(size: 24)
                    .foregroundStyle(.gray)
                    .padding(.top, 20)
                    .padding(.trailing, -16)
            }
            .onTapGesture {
                self.isExpanded = false
            }
            
            AlbumImageView(cornerRadius: 12, content: { self.artworkView })
            
            VStack(spacing: 8) {
                Text(self.playerState.albumName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(self.playerState.trackNameWithArtist)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            self.progressBarView
            
            HStack(spacing: 40) {
                Image(systemName: "backward.fill")
                    .onTap {
                        self.playerState.previousTrack()
                    }
                
                self.playpauseButton
                
                Image(systemName: "forward.fill")
                    .onTap {
                        self.playerState.nextTrack()
                    }
            }
            
            HStack {
                Image(systemName: "speaker.fill")
                
                Slider(
                    value: self.$volume,
                    in: 0...1
                )
                .tint(.white)
                
                MPVolumeSlider(volume: self.$volume, tintColor: .white)
                    .frame(size: 0)
                
                Image(systemName: "speaker.wave.3.fill")
            }
        }
        .padding(.horizontal, 36)
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .edgesIgnoringSafeArea(.bottom)
        )
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
    
    @ViewBuilder
    private var playpauseButton: some View {
        Group {
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
        .onTap {
            self.playerState.togglePlay()
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
        } else {
            Image(systemName: "music.note")
                .foregroundColor(.black.opacity(0.6))
        }
    }
}

#Preview {
    var state = MusicPlayerState(
        mediaService: DummyMediaPlayerService(),
        mediaSessionService: DummyMPMediaSessionService()
    )
    
    let album = Album(
        name: "앨범명1",
        artistName: "아티스트1",
        artworkImage: nil,
        tracks: [
            Track(
                title: "트랙1",
                duration: .zero,
                mediaItem: .init()
            )
        ]
    )
    
    state.playAlbum(album, playMode: .sequence)
    
    return MusicPlayerView()
        .environmentObject(state)
}
