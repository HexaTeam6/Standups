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
        @PresentationState var destination: Destination.State?
        var standup: Standup
    }

    enum Action: Equatable {
        case deleteButtonTapped
        case deleteMeetings(atOffsets: IndexSet)
        case editButtonTapped
        case saveStandupButtonTapped
        case cancelStandupButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case deleteStandup(id: Standup.ID)
            case standupUpdate(Standup)
        }
    }

    @Dependency(\.dismiss) var dismiss

    @Reducer
    struct Destination {
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case editStandup(StandupFormFeature.State)
        }

        enum Action: Equatable {
            case alert(Alert)
            case editStandup(StandupFormFeature.Action)
            enum Alert {
                case confirmDeletion
            }
        }

        var body: some ReducerOf<Self> {
            Scope(state: \.editStandup, action: \.editStandup) {
                StandupFormFeature()
            }
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.alert(.confirmDeletion))):
                return .run { [id = state.standup.id] send in
                    await send(.delegate(.deleteStandup(id: id)))
                    await self.dismiss()
                }

            case .destination:
                return .none

            case .deleteButtonTapped:
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure you want to delete?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
                
            case .deleteMeetings(atOffsets: let indices):
                state.standup.meetings.remove(atOffsets: indices)
                return .none
                
            case .editButtonTapped:
                state.destination = .editStandup(StandupFormFeature.State(standup: state.standup))
                return .none
                
            case .saveStandupButtonTapped:
                guard case let .editStandup(standupForm) = state.destination
                else { return .none }
                
                state.standup = standupForm.standup
                state.destination = nil
                return .none
                
            case .cancelStandupButtonTapped:
                state.destination = nil
                return .none
                
            case .delegate:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
        .onChange(of: \.standup) { oldValue, newValue in
            Reduce { state, action in
                .send(.delegate(.standupUpdate(newValue)))
            }
        }
    }
}
