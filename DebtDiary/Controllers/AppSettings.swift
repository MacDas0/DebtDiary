//
//  ColorManager.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI

class AppSettings: ObservableObject {
    
    @Published var colorTheme: Color = Color.customGreen
    func gradient() -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [colorTheme, Color.backgroundDark]),
            startPoint: .leading,
            endPoint: .trailing
            )
    }
    func gradient(color: Color) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [color, Color.backgroundDark]),
            startPoint: .leading,
            endPoint: .trailing
            )
    }
    
    let supportedCurrencies = ["PLN", "USD", "EURO", "BAHT"]
    @Published var currency = "PLN"
    
    let supportedLanguages = ["Polish", "English"]
    @Published var language = "Polish"
    
    @Published var UseHaptics = true
}
