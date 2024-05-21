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
            case recordMeeting(RecordMeetingFeature.State)
        }

        enum Action: Equatable {
            case detail(StandupDetailFeature.Action)
            case recordMeeting(RecordMeetingFeature.Action)
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                StandupDetailFeature()
            }
            Scope(state: \.recordMeeting, action: \.recordMeeting) {
                RecordMeetingFeature()
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
                case let .deleteStandup(id: id):
                    state.standupsList.standups.remove(id: id)
                    return .none

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
