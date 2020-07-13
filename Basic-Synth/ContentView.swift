//
//  ContentView.swift
//  Basic-Synth
//
//  Created by Nathan Sepulveda on 7/12/20.
//  Copyright © 2020 Nathan Sepulveda. All rights reserved.
//

import SwiftUI
import AudioKit
import AudioKitUI

struct ContentView: View {
    @EnvironmentObject var data: DataModel
    
    
    var body: some View {
        
        Form {
            Button(action: data.toggleSound) {
                Text(data.sound ? "Sound on" : "Sound Off" )
            }
            VStack {
                Text("Amplitude (0-5)")
                Slider(value: $data.amplitude, in: 0.0...5.0)
                Text("\(data.amplitude)")
            }
            VStack {
                Text("Frequency (0-1500Hz)")
                Slider(value: $data.frequency, in: 0.0...1500.0)
                Text("\(data.frequency)")

            }
            Button(action: data.record) {
                Text(data.recording ? "Recording": "Record")
            }
            Button(action: data.play) {
                Text(data.playing ? "Playing" : "Play")
            }
            Button(action: data.loadDemo) {
                Text("Load Demo")
            }
            Button(action: data.delete) {
                Text("Delete")
            }
            
        }
    }
}



struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
