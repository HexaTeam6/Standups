//
//  StandupsListView.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import SwiftUI
import ComposableArchitecture

struct StandupsListView: View {
    let store: StoreOf<StandupsListFeature>
    var body: some View {
        WithViewStore(store, observe: \.standups) { viewStore in
            List {
                ForEach(viewStore.state) { standup in
                    CardView(standup: standup)
                        .listRowBackground(standup.theme.mainColor)
                }
            }
            .navigationTitle("Daily Standups")
            .toolbar {
                ToolbarItem {
                    Button("Add") {
                        viewStore.send(.addButtonTapped)
                    }
                }
            }
            .sheet(
                store: store.scope(
                    state: \.$addStandup,
                    action: \.addStandup
                )
            ) { store in
                NavigationStack {
                    StandupFormView(store: store)
                        .navigationTitle("New Standup")
                        .toolbar {
                            ToolbarItem {
                                Button("Save") {
                                    viewStore.send(.saveStandupButtonTapped)
                                }
                            }
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewStore.send(.cancelStandupButtonTapped)
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        StandupsListView(store: Store(
            initialState: StandupsListFeature.State(
                standups: [.mock]
            )) {
                StandupsListFeature()
                    ._printChanges()
            }
        )
    }
}
