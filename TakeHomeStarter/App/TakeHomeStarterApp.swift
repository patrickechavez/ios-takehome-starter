//
//  TakeHomeStarterApp.swift
//  TakeHomeStarter
//  Created by John Patrick Echavez
//

import SwiftUI

@main
struct TakeHomeStarterApp: App {

    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
