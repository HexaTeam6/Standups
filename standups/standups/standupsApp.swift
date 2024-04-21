//
//  standupsApp.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct standupsApp: App {
    var body: some Scene {
        WindowGroup {
            StandupFormView(store: Store(
                initialState: StandupFormFeature.State(standup: .mock)) {
                    StandupFormFeature()
                }
            )
        }
    }
}
