//
//  AppView.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 12/05/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            StandupsListView(store: store.scope(
                state: \.standupsList,
                action: \.standupsList
            ))
        } destination: { state in
            switch state {
            case .detail:
                CaseLet(
                    /AppFeature.Path.State.detail,
                     action: AppFeature.Path.Action.detail,
                     then: StandupDetailView.init(store:)
                )
            case .recordMeeting:
                CaseLet(
                    /AppFeature.Path.State.recordMeeting,
                     action: AppFeature.Path.Action.recordMeeting,
                     then: RecordMeetingView.init(store:)
                )
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State(
                standupsList: StandupsListFeature.State(standups: [.mock])
            )
        ) {
            AppFeature()
                ._printChanges()
        }
    )
}
