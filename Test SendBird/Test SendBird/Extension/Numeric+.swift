//
//  Numeric+.swift
//  Test SendBird
//
//  Created by Đạt on 9/19/20.
//  Copyright © 2020 Tracker. All rights reserved.
//

import Foundation

extension Numeric{
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter.string(for: self) ?? String(describing: self)
    }
}
