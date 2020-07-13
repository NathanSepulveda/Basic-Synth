//
//  DataModel.swift
//  Basic-Synth
//
//  Created by Nathan Sepulveda on 7/12/20.
//  Copyright © 2020 Nathan Sepulveda. All rights reserved.
//

import Foundation
import AudioKit

final class DataModel : ObservableObject {
    // The single shared insance of this class that we will use
    static let shared = DataModel()
    
    //the oscillator that we will set the frequency and aplitude of
    private let oscillator = AKOscillator()
    
    // the second oscillator that will be mixed with the first
    
    private let oscillator2 = AKOscillator()
    
    private let oscillator3 = AKOscillator()
    
    private let oscillator4 = AKOscillator()
    
    //whether sound is enabled
    @Published var sound = false
    
    //whether slider movements are being recorded
    @Published var recording = false
    
    //whether slider movements are being plaued
    @Published var playing = false
    
    @Published var amplitude = 0.5 {
        didSet {setAmplitudeAndFrequency()}
    }
    
    @Published var frequency = 220.0 {
    
        didSet {setAmplitudeAndFrequency()}
    }
    
    private var timer = Timer()
    
    private var recordedAmplitudes = [Double]()
    
    private var recordedFrequencies = [Double]()
    
    private let demoRecordedFrequencies = [440.0, 220.0, 440.0]
    
    private let demoRecordedAmplitudes = [1.0, 6.0, 4.0]
    
    private var ampIndex = 0
    private var freqIndex = 0
    
    init() {
        AudioKit.output = AKMixer(oscillator, oscillator2, oscillator3, oscillator4)
        do {
            try AudioKit.start()
        }
        catch {
            assert(false, "Failed to start AudioKit")
        }
    }
    
    func setAmplitudeAndFrequency() {
        oscillator.amplitude = amplitude
        oscillator.frequency = frequency
        oscillator2.amplitude = amplitude
        oscillator2.frequency = frequency * 3
        oscillator3.amplitude = amplitude
        oscillator3.frequency = frequency * 5
        oscillator4.amplitude = amplitude
        oscillator4.frequency = frequency * 7
    }
    
    func record()  {
        playing = false
        recording = !recording
        timer.invalidate()
        if recording {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in self.recordSliders()})
        }
    }
    
    func play() {
        recording = false
        playing = !playing
        timer.invalidate()
        if playing {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in self.moveSliders()})
        }
    }
    
    func recordSliders() {
        recordedAmplitudes.append(amplitude)
        recordedFrequencies.append(frequency)
    }
    
    func moveSliders() {
        if recordedAmplitudes.count == 0 && recordedFrequencies.count == 0 {
            playing = false
        }
        if playing {
            if recordedAmplitudes.count != 0 {
                amplitude = recordedAmplitudes[ampIndex]
                ampIndex += 1
                if ampIndex == recordedAmplitudes.count {
                    ampIndex = 0
                }
            }
            if recordedFrequencies.count != 0 {
                frequency = recordedFrequencies[freqIndex]
                freqIndex += 1
                if freqIndex == recordedFrequencies.count {
                    freqIndex = 0
                }
            }
            setAmplitudeAndFrequency()
        }
    }
    
    func delete() {
        recordedAmplitudes.removeAll()
        recordedFrequencies.removeAll()
    }
    
    func loadDemo () {
        ampIndex = 0
        freqIndex = 0
        recordedAmplitudes = demoRecordedAmplitudes
        recordedFrequencies = demoRecordedFrequencies
    }
    
    func toggleSound() {
        if oscillator.isPlaying {
            oscillator.stop()
            oscillator2.stop()
            oscillator3.stop()
            oscillator4.stop()
            
        } else {
            oscillator.amplitude = amplitude
            oscillator.frequency = frequency
            oscillator.start()
            oscillator2.frequency = frequency * 3
            oscillator2.amplitude = amplitude
            oscillator2.start()
            oscillator3.frequency = frequency * 5
            oscillator3.amplitude = amplitude
            oscillator3.start()
            oscillator4.frequency = frequency * 7
            oscillator4.amplitude = amplitude
            oscillator4.start()
        }
        sound = oscillator.isPlaying
        
        
    }
    
}
