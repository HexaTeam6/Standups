//
//  Duration+Extension.swift
//  standups
//
//  Created by Abdur Rachman Wahed on 21/04/24.
//

import Foundation

extension Duration {
    var minutes: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60) }
    }
}
