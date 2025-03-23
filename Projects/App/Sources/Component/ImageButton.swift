//
//  AppButton.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/23/25.
//

import SwiftUI

struct ImageButton: View {
    private let image: Image
    private let size: CGFloat
    private let isShowBorder: Bool
    private let action: () -> Void
    
    init(
        systemName: String,
        size: CGFloat,
        isShowBorder: Bool = true,
        action: @escaping () -> Void
    ) {
        self.image = Image(systemName: systemName)
        self.size = size
        self.isShowBorder = isShowBorder
        self.action = action
    }
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Spacer()
                self.image
                    .resizable()
                    .frame(width: self.size, height: self.size)
                    .scaledToFit()
                    .padding(8)
                    .cornerRadius(8)
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .foregroundStyle(.black)
        .background {
            if self.isShowBorder {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.gray.opacity(0.5), lineWidth: 1)
            } else {
                EmptyView()
            }
        }
    }
}
