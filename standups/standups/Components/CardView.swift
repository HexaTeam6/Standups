//
//  CardView.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import SwiftUI

struct CardView: View {
    let standup: Standup
    var body: some View {
        VStack(alignment: .leading) {
            Text(standup.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(standup.attendees.count)", systemImage: "person.3")
                    .accessibilityLabel("\(standup.attendees.count) attendees")
                Spacer()
                Label("", systemImage: "clock")
                    .accessibilityLabel(" minute meeting")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(standup.theme.accentColor)
    }
}
