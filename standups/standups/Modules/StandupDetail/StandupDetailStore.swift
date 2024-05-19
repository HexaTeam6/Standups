//
//  StandupDetailStore.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 28/04/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupDetailFeature {
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        @PresentationState var editStandup: StandupFormFeature.State?
        var standup: Standup
    }

    enum Action: Equatable {
        case deleteButtonTapped
        case deleteMeetings(atOffsets: IndexSet)
        case editButtonTapped
        case editStandup(PresentationAction<StandupFormFeature.Action>)
        case saveStandupButtonTapped
        case cancelStandupButtonTapped
        case delegate(Delegate)
        case alert(PresentationAction<Alert>)
        enum Alert {
            case confirmDeletion
        }
        enum Delegate: Equatable {
            case standupUpdate(Standup)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmDeletion)):
                // TODO: Delete this standup
                return .none

            case .alert(.dismiss):
                return .none
                
            case .deleteButtonTapped:
                state.alert = AlertState {
                    TextState("Are you sure you want to delete?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion) {
                        TextState("Delete")
                    }
                }
                return .none
                
            case .deleteMeetings(atOffsets: let indices):
                state.standup.meetings.remove(atOffsets: indices)
                return .none

            case .editButtonTapped:
                state.editStandup = StandupFormFeature.State(standup: state.standup)
                return .none

            case .editStandup:
                return .none

            case .saveStandupButtonTapped:
                guard let standup = state.editStandup?.standup
                else { return .none }

                state.standup = standup
                state.editStandup = nil
                return .none

            case .cancelStandupButtonTapped:
                state.editStandup = nil
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$editStandup, action: \.editStandup) {
            StandupFormFeature()
        }
        .onChange(of: \.standup) { oldValue, newValue in
            Reduce { state, action in
                .send(.delegate(.standupUpdate(newValue)))
            }
        }
    }
}
