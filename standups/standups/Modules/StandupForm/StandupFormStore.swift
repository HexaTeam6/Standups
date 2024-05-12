//
//  StandupFormStore.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct StandupFormFeature {
    struct State: Equatable {
        @BindingState var focus: Field?
        @BindingState var standup: Standup

        enum Field: Hashable {
            case attendee(Attendee.ID)
            case title
        }

        init(focus: Field? = .title, standup: Standup) {
            self.focus = focus
            self.standup = standup

            if self.standup.attendees.isEmpty {
                @Dependency(\.uuid) var uuid
                self.standup.attendees.append(Attendee(id: uuid()))
            }
        }
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addAttendeeButtonTapped
        case deleteAttendees(atOffsets: IndexSet)
    }

    @Dependency(\.uuid) var uuid

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none

            case .addAttendeeButtonTapped:
                let id = self.uuid()
                state.standup.attendees.append(Attendee(id: id))
                state.focus = .attendee(id)
                return .none

            case let .deleteAttendees(atOffsets: indices):
                state.standup.attendees.remove(atOffsets: indices)
                if state.standup.attendees.isEmpty {
                    state.standup.attendees.append(Attendee(id: self.uuid()))
                }

                guard let firstIndex = indices.first
                else { return .none }
                let index = min(firstIndex, state.standup.attendees.count - 1)
                state.focus = .attendee(state.standup.attendees[index].id)
                return . none
            }
        }
    }
}
