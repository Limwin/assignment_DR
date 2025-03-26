//
//  View+Extensions.swift
//  CommonExtension
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

public extension View {
    func onTap(
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            self
        }
        .foregroundColor(.black)
    }
    
    func frame(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
    
    @ViewBuilder
    func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func apply<Result: View>(@ViewBuilder modifier: (Self) -> Result?) -> some View {
        if let modifiedView = modifier(self) {
            modifiedView
        } else {
            self
        }
    }
}
