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
    
    func toUIColor() -> UIColor {
        UIColor(self)
    }

    func save(to userDefaults: UserDefaults, withKey key: String) {
        let uiColor = self.toUIColor()
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let colorComponents = [red, green, blue, alpha]
        userDefaults.set(colorComponents, forKey: key)
    }
    
    static func load(from userDefaults: UserDefaults, withKey key: String) -> Color? {
        guard let components = userDefaults.object(forKey: key) as? [CGFloat], components.count == 4 else {
            return nil
        }
        return Color(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), opacity: Double(components[3]))
    }
    
    static func name(for color: Color) -> String {
        switch color {
        case Color.customGreen:
            return "customGreen"
        case Color.limeGreen:
            return "limeGreen"
        case Color.yellowGreen:
            return "yellowGreen"
        case Color.customYellow:
            return "customYellow"
        case Color.gold:
            return "gold"
        case Color.customOrange:
            return "customOrange"
        case Color.coral:
            return "coral"
        case Color.redOrange:
            return "redOrange"
        case Color.customRed:
            return "customRed"
        case Color.crimson:
            return "crimson"
        case Color.magenta:
            return "magenta"
        case Color.deepPink:
            return "deepPink"
        case Color.customPurple:
            return "customPurple"
        case Color.blueViolet:
            return "blueViolet"
        case Color.customBlue:
            return "customBlue"
        case Color.dodgerBlue:
            return "dodgerBlue"
        case Color.customCyan:
            return "customCyan"
        case Color.turquoise:
            return "turquoise"
        case Color.aquamarine:
            return "aquamarine"
        default:
            return "basic"
        }
    }
}
