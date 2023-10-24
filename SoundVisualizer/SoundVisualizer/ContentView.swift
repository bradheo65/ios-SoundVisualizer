//
//  ContentView.swift
//  SoundVisualizer
//
//  Created by brad on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: 5)

    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (200 / 50)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                // 4
                ForEach(mic.soundSamples, id: \.self) { level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct BarView: View {
    var value: CGFloat = 0
    let numberOfSamples: Int = 5

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .frame(
                    width: 5,
                    height: value
                )
        }
    }
}
