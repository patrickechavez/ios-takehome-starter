//
//  TakeHomeStarterApp.swift
//  TakeHomeStarter
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
