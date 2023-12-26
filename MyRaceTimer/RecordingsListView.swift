//
//  RecordingsListView.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/25/23.
//

import SwiftUI

struct RecordingsListView: View {
    
    var recordings: [Recording]
    var selectedRecording: Recording?
    var selectRecording: (Recording) -> Void
    
    var body: some View {
        ZStack {
            List(recordings) { recording in
                Button {
                    self.selectRecording(recording)
                } label: {
                    HStack {
                        Text("\(String(recordings.firstIndex(of: recording) ?? 0)).")
                            .frame(width: 40, height: 20, alignment: .leading)
                            .padding(6)
                        Text(recording.plateLabel())
                            .frame(width: 80, height: 20)
                            .padding(6)
                            .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(UIColor.systemGray2), lineWidth: 0.5))
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .accessibilityLabel("Plate")
                        if recording.hasDuplicatePlateIn(recordings) {
                            Image(systemName: "square.on.square")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Text(recording.timestampString()).font(.subheadline.monospaced())
                    }
                }
            }
            .accessibilityLabel("Recordings")
            .listStyle(.inset)
            
            if recordings.isEmpty {
                Text("No recordings to display\nTap \"Record Time\" to create a recording.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
}

