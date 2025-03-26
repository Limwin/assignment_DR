//
//  MediaPlayerService.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/26/25.
//

import Foundation
import Combine
import MediaPlayer

enum MediaPlayerServiceAction {
    /// 재생 종료
    case playbackFinished
    /// 재생 시간 업데이트
    case progressUpdated(TimeInterval)
    /// 에러
    case error(Error)
}

protocol MediaPlayerService: AnyObject {
    var action: AnyPublisher<MediaPlayerServiceAction, Never> { get }
    var currentTime: TimeInterval { get }
    var duration: TimeInterval { get }
    var isPlaying: Bool { get }
    
    func play(mediaItem: MPMediaItem) async
    func pause()
    func resume()
    func stop()
    func setVolume(_ volume: Float)
    func seek(to time: TimeInterval)
}

final class DummyMediaPlayerService: MediaPlayerService {
    var currentTime: TimeInterval = 0
    var duration: TimeInterval = 0
    var isPlaying: Bool = false
    
    func play(mediaItem: MPMediaItem) async {}
    
    func pause() {}
    
    func resume() {}
    
    func stop() {}
    
    func setVolume(_ volume: Float) {}
    
    func seek(to time: TimeInterval) {}
    
    var action: AnyPublisher<MediaPlayerServiceAction, Never> {
        return Empty().eraseToAnyPublisher()
    }
}
