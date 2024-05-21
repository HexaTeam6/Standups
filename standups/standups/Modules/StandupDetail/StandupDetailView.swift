//
//  StandupDetailView.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 23/04/24.
//

import ComposableArchitecture
import SwiftUI

struct StandupDetailView: View {
    let store: StoreOf<StandupDetailFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    NavigationLink (
                        state: AppFeature.Path.State.recordMeeting(RecordMeetingFeature.State(standup: viewStore.standup))
                    ) {
                        Label("Start Meeting", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }

                    HStack {
                        Label("Length", systemImage: "clock")
                        Spacer()
                        Text(viewStore.standup.duration.formatted(.units()))
                    }

                    HStack {
                        Label("Theme", systemImage: "paintpalette")
                        Spacer()
                        Text(viewStore.standup.theme.name)
                            .padding(4)
                            .foregroundColor(viewStore.standup.theme.accentColor)
                            .background(viewStore.standup.theme.mainColor)
                            .cornerRadius(4)
                    }
                } header: {
                    Text("Standup Info")
                }

                if !viewStore.standup.meetings.isEmpty {
                    Section {
                        ForEach(viewStore.standup.meetings) { meeting in
                            NavigationLink {
    
                            } label: {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text(meeting.date, style: .date)
                                    Text(meeting.date, style: .time)
                                }
                            }
                        }
                        .onDelete { indices in
                            viewStore.send(.deleteMeetings(atOffsets: indices))
                        }
                    } header: {
                        Text("Past Meetings")
                    }
                }

                Section {
                    ForEach(viewStore.standup.attendees) { attendee in
                        Label(attendee.name, systemImage: "person")
                    }
                } header: {
                    Text("Attendees")
                }

                Section {
                    Button("Delete") {
                        viewStore.send(.deleteButtonTapped)
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(viewStore.standup.title)
            .toolbar {
                Button("Edit") {
                    viewStore.send(.editButtonTapped)
                }
            }
            .alert(
                store: self.store.scope(state: \.$destination, action: \.destination),
                state: /StandupDetailFeature.Destination.State.alert,
                action: StandupDetailFeature.Destination.Action.alert
            )
            .sheet(
                store: self.store.scope(state: \.$destination, action: \.destination),
                state: /StandupDetailFeature.Destination.State.editStandup,
                action: StandupDetailFeature.Destination.Action.editStandup
            ) { store in
                NavigationStack {
                    StandupFormView(store: store)
                        .navigationTitle("Edit Standup")
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
        StandupDetailView(store: Store(
            initialState: StandupDetailFeature.State(
                standup: .mock
            )) {
                StandupDetailFeature()
            }
        )
    }
}
