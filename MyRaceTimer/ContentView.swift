//
//  ContentView.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/21/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Button {
                    viewModel.handleRecordTime()
                } label: {
                    Text("Record Time")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.blue)
                        .border(Color(UIColor.systemGray5))
                }
                .padding(.top, 8)
                .padding(.bottom, -1)
                .accessibilityLabel("Record Time")
                
                HStack {
                    Text("^[\(viewModel.recordings.count) \("Recording")](inflect: true)")
                    Spacer()
                    if viewModel.timerIsActive {
                        Text("Since Last: \(viewModel.timeElapsedString)")
                            .onReceive(viewModel.timer) { _ in
                                viewModel.updateTime()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .font(.footnote)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .border(Color(UIColor.systemGray4))
                .background(Color(UIColor.systemGray6))
                
                RecordingsListView(
                    recordings: viewModel.recordings,
                    selectedRecordingId: viewModel.selectedRecordingId,
                    selectRecording: { (recording: Recording) in viewModel.handleSelectRecording(recording)
                    }
                )
                
                Button {
                    viewModel.handleAddPlate()
                } label: {
                    Text("Add Plate Number")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .border(Color(UIColor.systemGray4))
                        .background(Color(UIColor.systemGray6))
                }
                .padding(.bottom, -1)
                
                NumberPadView(onInputDigit: { (digit: Int) in
                    viewModel.handleAppendPlateDigit(digit)
                }, onBackspace: {
                    viewModel.handleRemoveLastPlateDigit()
                }, onDelete: {
                    viewModel.handleDeleteRecording()
                })
            }
            .navigationTitle("MyRaceTimer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Menu") {
                        Button("Calculate Results") {}
                        Button("Load Recording List") {}
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Recordings")
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
