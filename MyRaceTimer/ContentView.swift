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
        Text("deez")
/*
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
                    Text("^[\(viewModel.recordings.count)](inflect: true)")
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
                
                RecordingsList(recordings: viewModel.recordings, selectedRecording: viewModel.selectedRecording,selectRecording: { (recording: Recording) in viewModel.handleSelectRecording(recording: recording)})
                
                if viewModel.displayingUpcomingPlateButton() {
                    Button {
                        viewModel.handleAddUpcomingPlate()
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
                }
                
                NumberPad(onInputDigit: { (digit: Int) in
                    viewModel.handleAppendPlateDigit(digit: digit)
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
                    Button {
                        viewModel.presentingResultSheet = true
                    } label: {
                        Text("Results")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.presentingRecordingSetsSheet = true
                    } label: {
                        Text("Recordings")
                    }
                }
            }
            .sheet(isPresented: $viewModel.presentingRecordingSetsSheet) {
                RecordingSetsSheet(update: {
                    viewModel.updateRecordings()
                }, deactivateTimer: {
                    viewModel.deactivateTimer()
                })
            }
            .sheet(isPresented: $viewModel.presentingResultSheet) {
                ResultSheet()
            }
            .alert("Successfully Imported Recording Set!", isPresented: $viewModel.presentingSuccessfulImportAlert, actions: {
                Button("Ok", role: .cancel, action: {})
            })
            .alert("Error Importing Recording Set!", isPresented: $viewModel.presentingImportErrorAlert, actions: {
                Button("Ok", role: .cancel, action: {})
            })
            .ignoresSafeArea(.keyboard)
        }
*/
    }
}
