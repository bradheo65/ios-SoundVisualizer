//
//  MicrophoneMonitor.swift
//  SoundVisualizer
//
//  Created by brad on 10/24/23.
//

import Foundation
import AVFoundation

final class MicrophoneMonitor: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    private var currentSample: Int = 0
    private let numberOfSamples: Int
    
    @Published var soundSamples: [Float] = []
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { isGranted in
                if !isGranted {
                    print("Fail")
                }
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSetting: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSetting)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            startMonitoring()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        timer?.invalidate()
        audioRecorder?.stop()
    }
    
    private func startMonitoring() {
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.audioRecorder?.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder?.averagePower(forChannel: 0) ?? 0
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
    }
}
