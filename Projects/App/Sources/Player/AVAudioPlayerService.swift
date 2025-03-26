//
//  AVAudioPlayerService.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/26/25.
//

import Foundation
import Combine

enum AVAudioPlayerServiceAction {
    /// 재생 종료
    case playbackFinished
    /// 재생 시간 업데이트
    case progressUpdated(TimeInterval)
    /// 에러
    case error(Error)
}

protocol AVAudioPlayerService: AnyObject {
    var action: AnyPublisher<AVAudioPlayerServiceAction, Never> { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    var isPlaying: Bool { get }
    
    func setup()
    func play(url: URL)
    func pause()
    func resume()
    func stop()
    func setVolume(_ volume: Float)
    func seek(to time: TimeInterval)
}

final class DummyAVAudioPlayerService: AVAudioPlayerService {
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var isPlaying: Bool = false
    
    func setup() {}
    
    func play(url: URL) {}
    
    func pause() {}
    
    func resume() {}
    
    func stop() {}
    
    func setVolume(_ volume: Float) {}
    
    func seek(to time: TimeInterval) {}
    
    var action: AnyPublisher<AVAudioPlayerServiceAction, Never> {
        return Empty().eraseToAnyPublisher()
    }
}
