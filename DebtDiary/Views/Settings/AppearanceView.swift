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

    var body: some View {
        NavigationStack {
            List {
                // Preview
                Section {
                    HStack {Text("Preview")}.listRowBackground(appSettings.gradient())
                }
                // All Colors
                Section {
                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.yellowGreen)).tint(Color.yellowGreen)
                        .onTapGesture { self.appSettings.colorTheme = Color.yellowGreen }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customYellow)).tint(Color.customYellow)
                        .onTapGesture { self.appSettings.colorTheme = Color.customYellow }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.gold)).tint(Color.gold)
                        .onTapGesture { self.appSettings.colorTheme = Color.gold }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customOrange)).tint(Color.customOrange)
                        .onTapGesture { self.appSettings.colorTheme = Color.customOrange }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.coral)).tint(Color.coral)
                        .onTapGesture { self.appSettings.colorTheme = Color.coral }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.redOrange)).tint(Color.redOrange)
                        .onTapGesture { self.appSettings.colorTheme = Color.redOrange }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customRed)).tint(Color.customRed)
                        .onTapGesture { self.appSettings.colorTheme = Color.customRed }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.crimson)).tint(Color.crimson)
                        .onTapGesture { self.appSettings.colorTheme = Color.crimson }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.magenta)).tint(Color.magenta)
                        .onTapGesture { self.appSettings.colorTheme = Color.magenta }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.deepPink)).tint(Color.deepPink)
                        .onTapGesture { self.appSettings.colorTheme = Color.deepPink }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customPurple)).tint(Color.customPurple)
                        .onTapGesture { self.appSettings.colorTheme = Color.customPurple }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.blueViolet)).tint(Color.blueViolet)
                        .onTapGesture { self.appSettings.colorTheme = Color.blueViolet }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customBlue)).tint(Color.customBlue)
                        .onTapGesture { self.appSettings.colorTheme = Color.customBlue }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.dodgerBlue)).tint(Color.dodgerBlue)
                        .onTapGesture { self.appSettings.colorTheme = Color.dodgerBlue }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.customCyan)).tint(Color.customCyan)
                        .onTapGesture { self.appSettings.colorTheme = Color.customCyan }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.turquoise)).tint(Color.turquoise)
                        .onTapGesture { self.appSettings.colorTheme = Color.turquoise }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.aquamarine)).tint(Color.aquamarine)
                        .onTapGesture { self.appSettings.colorTheme = Color.aquamarine }

                    TextField("", text: .constant(""))
                        .listRowBackground(appSettings.gradient(color: Color.darkBlack)).tint(Color.darkBlack)
                        .onTapGesture { self.appSettings.colorTheme = Color.darkBlack }

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
