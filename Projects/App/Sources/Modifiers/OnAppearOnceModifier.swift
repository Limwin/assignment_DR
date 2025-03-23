//
//  OnAppearOnceModifier.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

extension View {
    func onAppearOnce(perform action: @escaping () -> Void) -> some View {
        modifier(OnAppearOnceModifier(action: action))
    }
}

private struct OnAppearOnceModifier: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !self.hasAppeared {
                    self.hasAppeared = true
                    self.action()
                }
            }
    }
}
