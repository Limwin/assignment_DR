//
//  AlbumImageView.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/27/25.
//

import SwiftUI

struct AlbumImageView<Content: View>: View {
    private var cornerRadius: CGFloat
    private var size: CGFloat?
    private var backgroundColor: Color
    private var aspectRatio: CGFloat?
    private let content: Content
    
    init(
        cornerRadius: CGFloat,
        size: CGFloat? = nil,
        backgroundColor: Color = .gray.opacity(0.7),
        aspectRatio: CGFloat? = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.size = size
        self.backgroundColor = backgroundColor
        self.aspectRatio = aspectRatio
        self.content = content()
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: self.cornerRadius)
            .fill(self.backgroundColor)
            .apply { rectangle in
                if let size {
                    rectangle.frame(size: size)
                } else {
                    rectangle
                }
            }
            .apply { rectangle in
                if let aspectRatio {
                    rectangle.aspectRatio(aspectRatio, contentMode: .fit)
                } else {
                    rectangle
                }
            }
            .overlay(
                self.content.clipShape(RoundedRectangle(cornerRadius: self.cornerRadius))
            )
            
    }
}
