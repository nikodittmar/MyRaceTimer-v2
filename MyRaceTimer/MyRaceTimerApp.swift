//
//  MyRaceTimerApp.swift
//  MyRaceTimer
//
//  Created by Niko Dittmar on 12/21/23.
//

import SwiftUI

@main
struct MyRaceTimerApp: App {
    @StateObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onOpenURL(perform: { url in
                    viewModel.handleImportRecordingList(url: url)
                })
        }
    }
}
