//
//  MediaPlayerServiceImpl.swift
//  MediaPlayerService
//
//  Created by seunghyeok lim on 4/1/25.
//

import Combine
import MediaPlayer

import MediaPlayerServiceInterface

public final class MediaPlayerServiceImpl: MediaPlayerService {
    
    public var action: AnyPublisher<MediaPlayerServiceAction, Never> {
        self.actionSubject.eraseToAnyPublisher()
    }
    private let actionSubject = PassthroughSubject<MediaPlayerServiceAction, Never>()
    
    public var duration: TimeInterval {
        self.player.nowPlayingItem?.playbackDuration ?? 0
    }
    
    private var isPlaying: Bool {
        self.player.playbackState == .playing
    }
    
    private var currentTime: TimeInterval {
        self.player.currentPlaybackTime
    }
    
    private let player = MPMusicPlayerController.applicationMusicPlayer
    private let playingInfoCenter = MPNowPlayingInfoCenter.default()
    private var progressTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        self.setupAudioSession()
    }
    
    @MainActor
    public func play(mediaItem: MPMediaItem) async {
        do {
            self.player.setQueue(with: .init(items: [mediaItem]))
            try await self.player.prepareToPlay()
            self.player.play()
            
            self.startProgressTimer()
        } catch {
            self.actionSubject.send(.error(error))
        }
    }
    
    public func pause() {
        self.player.pause()
        self.progressTimer?.invalidate()
    }
    
    public func resume() {
        self.player.play()
        self.startProgressTimer()
    }
    
    public func stop() {
        self.player.stop()
        self.progressTimer?.invalidate()
    }
    
    public func seek(to time: TimeInterval) {
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
            self.actionSubject.send(.progressUpdated(self.currentTime))
            
            // 재생 상태가 아니고 현재 음악의 실행 시간이 0일 경우는 재생이 끝난 상태입니다.
            if !self.isPlaying, self.currentTime == 0 {
                self.actionSubject.send(.playbackFinished)
                self.stop()
            }
        }
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: [])
            self.bindPlayerStateChangeNotification()
        } catch {
            self.actionSubject.send(.error(error))
        }
    }
    
    private func bindPlayerStateChangeNotification() {
        NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleRouteChange(notification: notification)
            }
            .store(in: &self.cancellables)
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
                self.actionSubject.send(.pause)
            }
        case .newDeviceAvailable:
            if !self.isPlaying {
                self.player.play()
                self.actionSubject.send(.play)
            }
            
        default:
            break
        }
    }
    
    deinit {
        try? AVAudioSession.sharedInstance().setActive(false)
        self.progressTimer?.invalidate()
        self.progressTimer = nil
        self.player.stop()
        self.cancellables.removeAll()
    }
}
