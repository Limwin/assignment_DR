//
//  AVAudioPlayerService.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/25/25.
//

import AVFoundation
import Combine

final class AVAudioPlayerService {
    
    // FIXME: - Error를 커스텀하게 정의할지 고민해봐야함.
    enum Action {
        /// 재생 종료
        case playbackFinished
        /// 재생 시간 업데이트
        case progressUpdated(TimeInterval)
        /// 재생 상태 변경(재생, 일시정지)
        case playbackStateChanged(Bool)
        /// 에러
        case error(Error)
    }
    
    var action: AnyPublisher<Action, Never> {
        self.actionSubject.eraseToAnyPublisher()
    }
    private let actionSubject = PassthroughSubject<Action, Never>()
    
    var currentTime: TimeInterval {
        self.player?.currentTime ?? 0
    }
    
    var duration: TimeInterval {
        self.player?.duration ?? 0
    }
    
    var isPlaying: Bool {
        self.player?.isPlaying ?? false
    }
    
    private var player: AVAudioPlayer?
    private var progressTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    func setup() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            NotificationCenter.default
                .publisher(for: AVAudioSession.routeChangeNotification)
                .sink { [weak self] notification in
                    self?.handleRouteChange(notification: notification)
                }
                .store(in: &self.cancellables)
            
        } catch {
            self.actionSubject.send(.error(error))
        }
    }
    
    func play(url: URL) {
        self.stop()
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.prepareToPlay()
            self.player?.play()
            
            self.actionSubject.send(.playbackStateChanged(true))
            self.startProgressTimer()
        } catch {
            self.actionSubject.send(.error(error))
        }
    }
    
    func pause() {
        self.player?.pause()
        self.progressTimer?.invalidate()
        self.actionSubject.send(.playbackStateChanged(false))
    }
    
    func resume() {
        self.player?.play()
        self.actionSubject.send(.playbackStateChanged(true))
        self.startProgressTimer()
    }
    
    func stop() {
        self.player?.stop()
        self.progressTimer?.invalidate()
        self.player = nil
    }
    
    private func startProgressTimer() {
        self.progressTimer?.invalidate()
        
        self.progressTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: true
        ) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            
            let currentTime = player.currentTime
            self.actionSubject.send(.progressUpdated(currentTime))
            
            if currentTime >= player.duration {
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
                self.player?.pause()
                self.actionSubject.send(.playbackStateChanged(false))
            }
        case .newDeviceAvailable:
            if !self.isPlaying {
                self.player?.play()
                self.actionSubject.send(.playbackStateChanged(true))
            }
            
        default:
            break
        }
    }
    
    deinit {
        self.progressTimer?.invalidate()
        self.player?.stop()
        self.cancellables.removeAll()
        
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
