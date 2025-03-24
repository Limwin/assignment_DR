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
    }
    
    func frame(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }
}
