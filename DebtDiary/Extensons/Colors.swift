//
//  Colors.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

extension Color {
    init(hex: UInt) {
        self.init(
            .sRGB,
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0
        )
    }
    
    static let backgroundDark = Color(hex: 0xC0C0C)
    static let customGreen = Color(hex: 0x005700)
    static let limeGreen = Color(hex: 0x1E7A1E)
    static let yellowGreen = Color(hex: 0x657D32)
    static let customYellow = Color(hex: 0xB3B300)
    static let gold = Color(hex: 0xB38600)
    static let customOrange = Color(hex: 0xB35900)
    static let coral = Color(hex: 0xB34D3A)
    static let redOrange = Color(hex: 0xB33D1A)
    static let customRed = Color(hex: 0xB30000)
    static let crimson = Color(hex: 0x8B1037)
    static let magenta = Color(hex: 0xB300B3)
    static let deepPink = Color(hex: 0xB3006B)
    static let customPurple = Color(hex: 0x550055)
    static let blueViolet = Color(hex: 0x5B1A96)
    static let customBlue = Color(hex: 0x0000B3)
    static let dodgerBlue = Color(hex: 0x1360A3)
    static let customCyan = Color(hex: 0x008B8B)
    static let turquoise = Color(hex: 0x307B7F)
    static let aquamarine = Color(hex: 0x4FAFA7)
    static let darkBlack = Color(hex: 0x000000)

}
