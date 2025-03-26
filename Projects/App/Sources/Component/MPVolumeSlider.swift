//
//  MPVolumeSlider.swift
//  MusicPlayer
//
//  Created by seunghyeok lim on 3/27/25.
//

import SwiftUI
import MediaPlayer
import Combine

struct MPVolumeSlider: UIViewRepresentable {
    
    @Binding var volume: Float
    var tintColor: UIColor = .white
    
    func makeUIView(context: Context) -> MPVolumeView {
        let volumeView = MPVolumeView(frame: .zero)
        volumeView.isHidden = true
        
        context.coordinator.setupVolumeObserver()
        
        return volumeView
    }
    
    func updateUIView(_ uiView: MPVolumeView, context: Context) {
        if let slider = uiView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            slider.setValue(self.volume, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        private var parent: MPVolumeSlider
        private var cancellables = Set<AnyCancellable>()
        
        init(_ parent: MPVolumeSlider) {
            self.parent = parent
        }
        
        deinit {
            try? AVAudioSession.sharedInstance().setActive(false)
        }
        
        func setupVolumeObserver() {
            try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try? AVAudioSession.sharedInstance().setActive(true)
            
            DispatchQueue.main.async {
                self.parent.volume = AVAudioSession.sharedInstance().outputVolume
            }
            
            AVAudioSession.sharedInstance()
                .publisher(for: \.outputVolume)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] volume in
                    self?.parent.volume = volume
                }
                .store(in: &self.cancellables)
        }
    }
}
