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
            var editedStandup = Standup.mock
            let _ = editedStandup.title += " Morning Sync"
            AppView(
                store: Store(
                    initialState: AppFeature.State(
                        path: StackState([
                            .detail(StandupDetailFeature.State(
                                destination: StandupDetailFeature.Destination.State.editStandup(
                                    StandupFormFeature.State(
                                        focus: .title,
                                        standup: .mock
                                    )
                                ),
                                standup: .mock
                            ))
                        ]),
                        standupsList: StandupsListFeature.State(standups: [.mock])
                    )
                ) {
                    AppFeature()
                        ._printChanges()
                }
            )
        }
    }
}
