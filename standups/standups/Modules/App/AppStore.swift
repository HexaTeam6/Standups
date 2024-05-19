//
//  AppStore.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 12/05/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var standupsList = StandupsListFeature.State()
    }

    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case standupsList(StandupsListFeature.Action)
    }

    @Reducer
    struct Path {
        enum State: Equatable {
            case detail(StandupDetailFeature.State)
        }

        enum Action: Equatable {
            case detail(StandupDetailFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                StandupDetailFeature()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.standupsList, action: \.standupsList) {
            StandupsListFeature()
        }

        Reduce { state, action in
            switch action {
            case let .path(.element(id: _, action: .detail(.delegate(action)))):
                switch action {
                case let .standupUpdate(standup):
                    state.standupsList.standups[id: standup.id] = standup
                    return .none
                }

            case .path:
                return .none

            case .standupsList:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}
