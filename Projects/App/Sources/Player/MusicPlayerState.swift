//
//  MusicPlayerState.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/24/25.
//

import UIKit
import Combine

final class MusicPlayerState: ObservableObject {
    
    enum PlayMode {
        case sequence
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
    
    private var trackIndex = 0
    private var currentAlbum: Album?
    private var currentTrack: Track? {
        self.currentAlbum?.tracks[self.trackIndex]
    }
    
    private var duration: TimeInterval {
        self.audioService.duration
    }
    
    private let audioService: AVAudioPlayerService
    private var cancellables: Set<AnyCancellable> = []
    
    init(audioService: AVAudioPlayerService) {
        self.audioService = audioService
        self.audioService.setup()
        
        self.bindingAudioService()
    }
    
    private func bindingAudioService() {
        self.audioService
            .action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self = self else { return }
                
                switch action {
                case .playbackFinished:
                    self.nextTrack()
                case .progressUpdated(let time):
                    self.currentTime = time
                case .playbackStateChanged(let isPlaying):
                    self.isPlaying = isPlaying
                case .error(let error):
                    print("\(error)")
                }
            }
            .store(in: &self.cancellables)
    }
    
    
    func playAlbum(_ album: Album, playMode: PlayMode) {
        switch playMode {
        case .sequence:
            self.currentAlbum = album
        case .random:
            let shuffledTracks = album.tracks.shuffled()
            self.currentAlbum = Album(
                name: album.name,
                artworkImage: album.artworkImage,
                tracks: shuffledTracks
            )
        }
        
        self.showMiniPlayer = true
        self.playTrack()
    }

    private func playTrack() {
        guard let currentTrack else { return }
        
        self.audioService.play(url: currentTrack.url)
    }
    
    func nextTrack() {
        let nextTrackIndex = self.trackIndex + 1
        let trackCount = self.currentAlbum?.tracks.count ?? 0
        
        guard nextTrackIndex < trackCount else {
            self.audioService.stop()
            isPlaying = false
            return
        }
        
        self.trackIndex = nextTrackIndex
        self.playTrack()
    }
    
    func progressWidth(totalWidth: CGFloat) -> CGFloat {
        if self.duration <= 0 { return 0 }
        let percentage = self.currentTime / self.duration
        return CGFloat(percentage) * totalWidth
    }
    
    func togglePlay() {
        if self.isPlaying {
            self.audioService.pause()
        } else {
            self.audioService.resume()
        }
    }
}
