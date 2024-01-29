//
//  AppearanceView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI

struct AppearanceView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    let secionHeader = "Color Theme"

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach([
                        (Color.customGreen, "Custom Green"),
                        (Color.limeGreen, "Custom Lime Green"),
                        (Color.yellowGreen, "Custom Yellow Green"),
                        (Color.customYellow, "Custom Yellow"),
                        (Color.gold, "Gold"),
                        (Color.customOrange, "Custom Orange"),
                        (Color.coral, "Coral"),
                        (Color.redOrange, "Red Orange"),
                        (Color.customRed, "Custom Red"),
                        (Color.crimson, "Crimson"),
                        (Color.magenta, "Magenta"),
                        (Color.deepPink, "Deep Pink"),
                        (Color.customPurple, "Custom Purple"),
                        (Color.blueViolet, "Blue Violet"),
                        (Color.customBlue, "Custom Blue"),
                        (Color.dodgerBlue, "Dodger Blue"),
                        (Color.customCyan, "Custom Cyan"),
                        (Color.turquoise, "Turquoise"),
                        (Color.aquamarine, "Aquamarine")
                    ], id: \.0) { color, name in
                        Button {
                            appSettings.colorTheme = color
                        } label: {
                            HStack {
                                Spacer()
                                if color == appSettings.colorTheme {
                                    Image(systemName: "checkmark").foregroundStyle(.white)
                                }
                            }.accessibilityLabel(name)
                        }
                        .listRowBackground(appSettings.gradient(color: color)) .tint(color)
                    }
                } header: { SectionHeader(text: "Color Theme") }
            }.background(Color.backgroundDark) .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("APPEARANCE").font(.myTitleBIG).foregroundStyle(appSettings.gradient())
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark") }
                }
            }

        }
    }
}

#Preview {
    AppearanceView()
}
