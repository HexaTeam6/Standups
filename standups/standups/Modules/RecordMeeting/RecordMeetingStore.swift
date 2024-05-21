//
//  RecordMeetingStore.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/05/24.
//

import Foundation
import Speech
import ComposableArchitecture

@Reducer
struct RecordMeetingFeature {
    struct State: Equatable {
        let standup: Standup
        var secondElapsed: Int = 0
        var speakerIndex: Int = 0

        var durationRemaining: Duration {
            standup.duration - .seconds(secondElapsed)
        }
    }

    enum Action: Equatable {
        case nextButtonTapped
        case endMeetingButtonTapped
        case onTask
        case timerTicked
    }

    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .none
                
            case .endMeetingButtonTapped:
                return .none

            case .onTask:
                return .run { send in
                    let status = await withUnsafeContinuation { continuation in
                        SFSpeechRecognizer.requestAuthorization { status in
                            continuation.resume(with: .success(status))
                        }
                    }

                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.timerTicked)
                    }
                }

            case .timerTicked:
                state.secondElapsed += 1
                return .none
            }
        }
    }
}
