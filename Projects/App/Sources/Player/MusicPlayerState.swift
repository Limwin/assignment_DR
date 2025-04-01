//
//  MusicPlayerState.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/24/25.
//

import UIKit
import Combine

import MediaSessionServiceInterface
import MediaPlayerServiceInterface

final class MusicPlayerState: ObservableObject {
    
    enum PlayMode {
        case sequence
        case trackIn(Track)
        case random
    }
    
    @Published private(set) var showMiniPlayer = false
    @Published private(set) var isPlaying = false
    @Published private var currentTime: TimeInterval = 0
    
    var albumName: String {
        self.currentAlbum?.name ?? ""
    }
    
    var trackNameWithArtist: String {
        let artistName = self.currentAlbum?.artistName ?? ""
        let trackTitle = self.currentTrack?.title ?? ""
        
        return "\(trackTitle) - \(artistName)"
    }
    
    var artworkImage: UIImage? {
        self.currentAlbum?.artworkImage
    }
    
    private var currentAlbum: Album?
    
    private var trackIndex = 0
    private var currentTrack: Track? {
        self.currentAlbum?.tracks[self.trackIndex]
    }
    
    private var duration: TimeInterval {
        self.mediaService.duration
    }
    
    private let mediaService: MediaPlayerService
    private let mediaSessionService: MPMediaSessionService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(mediaService: MediaPlayerService, mediaSessionService: MPMediaSessionService) {
        self.mediaService = mediaService
        
        self.mediaSessionService = mediaSessionService
        self.mediaSessionService.setup()
        
        self.bindingAudioService()
        self.bindingMediaSessionServcie()
    }
    
    private func bindingAudioService() {
        self.mediaService
            .action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self = self else { return }
                
                switch action {
                case .playbackFinished:
                    self.nextTrack()
                case .progressUpdated(let time):
                    self.currentTime = time
                case .play:
                    self.isPlaying = true
                case .pause:
                    self.isPlaying = false
                case .error(let error):
                    print("\(error)")
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func bindingMediaSessionServcie() {
        self.mediaSessionService
            .action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self = self else { return }
                
                switch action {
                case .play, .pause:
                    self.togglePlay()
                case .previous:
                    self.previousTrack()
                case .next:
                    self.nextTrack()
                }
            }
            .store(in: &self.cancellables)
    }
    
    func playAlbum(_ album: Album, playMode: PlayMode) {
        switch playMode {
        case .sequence:
            self.currentAlbum = album
        case .trackIn(let track):
            self.currentAlbum = album
            let trackIndex = album.tracks.firstIndex { $0.title == track.title } ?? 0
            self.trackIndex = trackIndex
        case .random:
            let shuffledTracks = album.tracks.shuffled()
            self.currentAlbum = Album(
                name: album.name,
                artistName: album.artistName,
                artworkImage: album.artworkImage,
                tracks: shuffledTracks
            )
        }
        
        self.showMiniPlayer = true
        Task {
            await self.playTrack()
        }
    }

    @MainActor
    private func playTrack() async {
        guard let currentTrack else { return }
        
        self.isPlaying = true
        await self.mediaService.play(mediaItem: currentTrack.mediaItem)
        self.updatePlayingInfo()
    }
    
    func previousTrack() {
        if currentTime >= 5.0 {
            self.mediaService.seek(to: 0)
            return
        }
        
        let previousTrackIndex = self.trackIndex - 1
        if previousTrackIndex < 0 {
            self.mediaService.seek(to: 0)
        } else {
            self.trackIndex = previousTrackIndex
            Task {
                await self.playTrack()
            }
        }
    }
    
    func nextTrack() {
        let nextTrackIndex = self.trackIndex + 1
        let trackCount = self.currentAlbum?.tracks.count ?? 0
        
        guard nextTrackIndex < trackCount else {
            self.mediaService.stop()
            self.isPlaying = false
            return
        }
        
        self.trackIndex = nextTrackIndex
        Task {
            await self.playTrack()
        }
    }
    
    func progressWidth(totalWidth: CGFloat) -> CGFloat {
        if self.duration <= 0 { return 0 }
        let percentage = self.currentTime / self.duration
        return CGFloat(percentage) * totalWidth
    }
    
    func togglePlay() {
        if self.isPlaying {
            self.mediaService.pause()
        } else {
            self.mediaService.resume()
        }
        
        self.isPlaying.toggle()
        self.updatePlayingInfo()
    }
    
    private func updatePlayingInfo() {
        guard let currentAlbum, let currentTrack else { return }
        
        self.mediaSessionService.updateNowPlayingInfo(
            title: currentTrack.title,
            artist: currentAlbum.artistName,
            albumName: currentAlbum.name,
            artwork: currentAlbum.artworkImage,
            duration: self.duration,
            currentTime: self.currentTime,
            isPlaying: self.isPlaying
        )
    }
}
