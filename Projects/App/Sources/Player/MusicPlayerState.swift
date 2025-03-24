//
//  MusicPlayerState.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/24/25.
//

import UIKit
import AVFoundation

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
        self.player?.duration ?? 0
    }
        
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
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

    func playTrack() {
        guard let currentTrack else { return }
        
        self.player?.stop()
        self.timer?.invalidate()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: currentTrack.url)
            self.player?.prepareToPlay()
            self.player?.play()
            self.isPlaying = true
            
            self.timer = Timer.scheduledTimer(
                withTimeInterval: 0.5,
                repeats: true
            ) { [weak self] _ in
                guard let self, let player else { return }
                
                let currentTime = player.currentTime
                self.currentTime = currentTime
                
                if currentTime >= player.duration {
                    self.nextTrack()
                }
            }
        } catch {
            
        }
    }
    
    private func nextTrack() {
        let nextTrackIndex = self.trackIndex + 1
        let trackCount = self.currentAlbum?.tracks.count ?? 0
        
        guard nextTrackIndex < trackCount else {
            self.player?.stop()
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
            self.player?.pause()
        } else {
            self.player?.play()
        }
        
        self.isPlaying.toggle()
    }
}
