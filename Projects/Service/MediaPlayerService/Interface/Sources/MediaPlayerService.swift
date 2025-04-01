//
//  MediaPlayerService.swift
//  MediaPlayerService
//
//  Created by seunghyeok lim on 4/1/25.
//

import Foundation
import Combine
import MediaPlayer

public enum MediaPlayerServiceAction {
    /// 재생 종료
    case playbackFinished
    /// 재생 시간 업데이트
    case progressUpdated(TimeInterval)
    /// 에러
    case error(Error)
    /// 재생 상태 변경
    case play
    case pause
}

public protocol MediaPlayerService: AnyObject {
    var action: AnyPublisher<MediaPlayerServiceAction, Never> { get }
    var duration: TimeInterval { get }
    
    func play(mediaItem: MPMediaItem) async
    func pause()
    func resume()
    func stop()
    func seek(to time: TimeInterval)
}
