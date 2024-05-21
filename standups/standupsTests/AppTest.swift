//
//  AppTest.swift
//  standupsTests
//
//  Created by Abdur Rachman Wahed on 19/05/24.
//

import XCTest
import ComposableArchitecture
@testable import standups

@MainActor
final class AppTest: XCTestCase {
    func testEdit() async throws {
        let standup = Standup.mock
        let store = TestStore(
            initialState: AppFeature.State(
                standupsList: StandupsListFeature.State(
                    standups: [standup]
                )
            )
        ){
            AppFeature()
        }

        await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup))))) {
            $0.path[id: 0] = .detail(StandupDetailFeature.State(standup: standup))
        }
        await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) {
            $0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = .editStandup(StandupFormFeature.State(standup: standup))
        }

        var editedStandup = standup
        editedStandup.title = "Code Review"
        await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup)))))))) {
            $0.path[id: 0, case: /AppFeature.Path.State.detail]?
                .$destination[case: \.editStandup]?.standup.title = "Code Review"
        }
        await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped)))) {
            $0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = nil
            $0.path[id: 0, case: /AppFeature.Path.State.detail]?.standup.title = "Code Review"
        }
        await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdate(editedStandup)))))) {
            $0.standupsList.standups[0].title = "Code Review"
        }
    }

    func testEdit_NonExhaustive() async throws {
        let standup = Standup.mock
        let store = TestStore(
            initialState: AppFeature.State(
                standupsList: StandupsListFeature.State(
                    standups: [standup]
                )
            )
        ){
            AppFeature()
        }

        store.exhaustivity = .off // to skip assertion so can only focus on specific action
        await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup)))))
        await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped))))

        var editedStandup = standup
        editedStandup.title = "Code Review"
        await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup))))))))
        await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped))))
        await store.skipReceivedActions() // skip for recive action
        store.assert {
            $0.standupsList.standups[0].title = "Code Review"
        }
    }

    func testDeletion_NonExhaustive() async throws {
        let standup = Standup.mock
        let store = TestStore(
            initialState: AppFeature.State(
                path: StackState([
                    .detail(
                        StandupDetailFeature.State(standup: standup)
                    )
                ]),
                standupsList: StandupsListFeature.State(
                    standups: [standup]
                )
            )
        ){
            AppFeature()
        }

        store.exhaustivity = .off
        await store.send(.path(.element(id: 0, action: .detail(.deleteButtonTapped))))
        await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.alert(.confirmDeletion)))))))
        await store.skipReceivedActions()
        store.assert {
            $0.path = StackState([])
            $0.standupsList.standups = []
        }
    }
}
