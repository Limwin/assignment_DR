//
//  LibraryDetailViewModel.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import Foundation

final class LibraryDetailViewModel: ObservableObject {
    
    let album: Album
    
    init(album: Album) {
        self.album = album
    }
}
