//
//  RecordingsView.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/29/23.
//

import SwiftUI
/*
struct RecordingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RecordingsViewModel
    
    init(updateRecordings: @escaping () -> Void, deactivateTimer: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: RecordingsViewModel(updateRecordings: updateRecordings, deactivateTimer: deactivateTimer))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Current Recording List")) {
                        TextField("Recording List Name", text: $viewModel.name)
                            .onSubmit {
                                viewModel.updateRecordingListName()
                            }
                        Picker("Recordings Type", selection: $viewModel.type) {
                            Text("Start")
                                .tag(RecordingListType.start)
                            Text("Finish")
                                .tag(RecordingListType.finish)
                        }
                        .onChange(of: viewModel.type) {
                            viewModel.updateRecordingListType()
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if viewModel.presentingDuplicatePlateWarning() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Duplicate Plate Numbers")
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                        
                        if viewModel.presentingMissingPlateWarning() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Plate Numbers")
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                        
                        if viewModel.presentingMissingTimestampWarning() {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow)
                                Text("Missing Timestamps")
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                    }
                    Section {
                        Button("Export as CSV") {
                            /*
                            viewModel.exportSelectedRecordingSetCSV()
                             */
                        }
                        .disabled(viewModel.recordingListIsEmpty())
                    }
                    Section {
                        Button("Delete Recording List", role: .destructive) {
                            viewModel.presentingDeleteRecordingListWarning = true
                        }
                        .disabled(viewModel.recordingListIsEmpty())
                    }
                    Section(header: Text("Saved Recording List")) {
                        Button("Create New Recording List") {
                            viewModel.createRecordingList()
                        }
                        .disabled(viewModel.recordingListIsEmpty())
                        Section {
                            List(viewModel.otherRecordingLists()) { recordingList in
                                Button {
                                    viewModel.selectRecordingList(recordingList)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(recordingList.name == "" ? "Untitled Stage" : recordingList.name)
                                                .padding(.top, 2)
                                                .lineLimit(1)
                                                .foregroundColor(recordingList.name == "" ? .gray : Color(UIColor.label))
                                            
                                            Text("^[\(recordingList.recordings.count) \("Recording")](inflect: true), \(recordingList.type.rawValue.capitalized)")
                                                .font(.caption)
                                                .padding(.bottom, 2)
                                                .foregroundColor(Color(UIColor.label))
                                        }
                                        Spacer()
                                        if recordingList.issueCount != 0 {
                                            HStack {
                                                Text(String(recordingList.issueCount))
                                                    .foregroundColor(Color(UIColor.label))
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Recording Lists"), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        viewModel.dismiss = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        /*
                        viewModel.exportSelectedRecordingSet()
                         */
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .disabled(viewModel.recordingListIsEmpty())
                }
            }
            .alert("Are you sure you want to delete this Recording Set?", isPresented: $viewModel.presentingDeleteRecordingListWarning, actions: {
                Button("No", role: .cancel, action: {})
                Button("Yes", role: .destructive, action: {
                    viewModel.deleteRecordingSet()
                })
            }, message: {
                Text("This cannot be undone.")
            })
            /*
            .sheet(isPresented: $viewModel.presentingShareSheet, content: {
                ActivityViewController(itemsToShare: viewModel.fileToShareURL)
            })
             */
            .onChange(of: viewModel.dismiss) { dismiss in
                if dismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

*/
