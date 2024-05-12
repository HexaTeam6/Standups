//
//  StandupDetailTest.swift
//  standupsTests
//
//  Created by Abdur Rachman Wahed on 01/05/24.
//

import XCTest
import ComposableArchitecture
@testable import standups

@MainActor
final class StandupDetailTest: XCTestCase {
    func testEdit() async throws {
        var standup = Standup.mock
        let store = TestStore(
            initialState: StandupDetailFeature.State(standup: standup)) {
                StandupDetailFeature()
            }
        store.exhaustivity = .off

        await store.send(.editButtonTapped)

        standup.title = "Code Review"
        await store.send(.editStandup(.presented(.set(\.$standup, standup))))

        await store.send(.saveStandupButtonTapped)
    }
}