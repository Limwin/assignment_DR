//
//  MediaPlayerServiceImpl.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/25/25.
//

import MediaPlayer
import Combine

final class MediaPlayerServiceImpl: MediaPlayerService {
    
    var action: AnyPublisher<MediaPlayerServiceAction, Never> {
        self.actionSubject.eraseToAnyPublisher()
    }
    private let actionSubject = PassthroughSubject<MediaPlayerServiceAction, Never>()
    
    var currentTime: TimeInterval {
        self.player.currentPlaybackTime
    }
    
    var duration: TimeInterval {
        self.player.nowPlayingItem?.playbackDuration ?? 0
    }
    
    var isPlaying: Bool {
        self.player.playbackState == .playing
    }
    
    private let player = MPMusicPlayerController.applicationMusicPlayer
    private let playingInfoCenter = MPNowPlayingInfoCenter.default()
    private var progressTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func play(mediaItem: MPMediaItem) async {
        do {
            self.player.setQueue(with: .init(items: [mediaItem]))
            try await self.player.prepareToPlay()
            self.player.play()
            
            self.startProgressTimer()
        } catch {
            self.actionSubject.send(.error(error))
        }
    }
    
    func pause() {
        self.player.pause()
        self.progressTimer?.invalidate()
    }
    
    func resume() {
        self.player.play()
        self.startProgressTimer()
    }
    
    func stop() {
        self.player.stop()
        self.progressTimer?.invalidate()
    }
    
    func setVolume(_ volume: Float) {
        
    }
    
    func seek(to time: TimeInterval) {
        guard self.player.nowPlayingItem != nil else { return }
        
        var nowPlayingInfo = self.playingInfoCenter.nowPlayingInfo ?? [:]
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
        self.playingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func startProgressTimer() {
        self.progressTimer?.invalidate()
        
        self.progressTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true
        ) { [weak self] _ in
            guard let self else { return }
            let currentTime = self.player.currentPlaybackTime
            self.actionSubject.send(.progressUpdated(currentTime))
            
            if currentTime >= self.duration {
                self.actionSubject.send(.playbackFinished)
            }
        }
    }
    
    private func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .oldDeviceUnavailable:
            if self.isPlaying {
                self.player.pause()
            }
        case .newDeviceAvailable:
            if !self.isPlaying {
                self.player.play()
            }
            
        default:
            break
        }
    }
    
    deinit {
        self.progressTimer?.invalidate()
        self.player.stop()
        self.cancellables.removeAll()
    }
}
