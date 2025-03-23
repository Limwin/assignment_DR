//
//  LibrarayView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

struct LibrarayView: View {
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Library")
            .onAppearOnce {
                self.viewModel.fetchAlbums()
            }
    }
}
