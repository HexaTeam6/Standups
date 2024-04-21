//
//  StandupFormTest.swift
//  standupsTests
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import ComposableArchitecture
import XCTest
@testable import standups

@MainActor
final class StandupFormTest: XCTestCase {
    func testAddDeleteAttendee() async {
        let store = TestStore(
            initialState: StandupFormFeature.State(
                standup: Standup(
                    id: UUID(),
                    attendees: [
                        Attendee(id: UUID())
                    ]
                )
            )
        ) {
            StandupFormFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addAttendeeButtonTapped) {
            $0.focus = .attendee(UUID(0))
            $0.standup.attendees.append(Attendee(id: UUID(0)))
        }

        await store.send(.deleteAttendees(atOffsets: [1])) {
            $0.focus = .attendee($0.standup.attendees[0].id)
            $0.standup.attendees.remove(at: 1)
        }
    }
}
