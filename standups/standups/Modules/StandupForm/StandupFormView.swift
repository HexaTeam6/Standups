//
//  StandupForm.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import ComposableArchitecture
import SwiftUI

struct StandupFormView: View {
    let store: StoreOf<StandupFormFeature>
    @FocusState var focus: StandupFormFeature.State.Field?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                Section {
                    TextField("Title", text: viewStore.$standup.title)
                        .focused($focus, equals: .title)
                    HStack {
                        Slider(value: viewStore.$standup.duration.minutes, in: 1...30, step: 1) {
                            Text("Length")
                        }
                        Spacer()
                        Text(viewStore.standup.duration.formatted(.units()))
                    }
                    ThemePicker(selection: viewStore.$standup.theme)
                } header: {
                    Text("Standup Info")
                }

                Section {
                    ForEach(viewStore.$standup.attendees) { $attendee in
                        TextField("Name", text: $attendee.name)
                            .focused($focus, equals: .attendee(attendee.id))
                    }
                    .onDelete { indices in
                        viewStore.send(.deleteAttendees(atOffsets: indices))
                    }

                    Button("Add attendee") {
                        viewStore.send(.addAttendeeButtonTapped)
                    }
                } header: {
                    Text("Attendees")
                }
            }
            .bind(viewStore.$focus, to: $focus)
        }
    }
}

#Preview {
    StandupFormView(store: Store(
        initialState: StandupFormFeature.State(standup: .mock)) {
            StandupFormFeature()
        }
    )
}
