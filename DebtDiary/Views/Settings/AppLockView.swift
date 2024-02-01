//
//  AppLockView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 25/01/2024.
//

import SwiftUI

struct AppLockView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    @State private var redGradient = false

    var body: some View {
        NavigationStack {
            List {
                Group {
                    Section {
                        Button {
                            appSettings.updateLockType()
                        } label: {
                            Text(redGradient ? "Create PIN Lock" : "Remove PIN Lock").font(.myMidMedium)
                        }.listRowBackground(redGradient ? appSettings.gradient() : appSettings.gradient(color: Color.customRed))
                    }
                    Section {
                        if appSettings.lockState == .lock {
                            Button {
                                appSettings.lockState = .editLock
                            } label: {
                                Text("Change PIN code").font(.myMidMedium)
                            }.listRowBackground(appSettings.gradient())
                        }
                    }
                }
            }.frame(maxWidth: .infinity) .background(Color.backgroundDark) .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("PIN LOCK").font(.myTitleBIG)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark") }
                }
            }
            .onAppear {
                redGradient = appSettings.lockState == .noLock
            }
        }
    }
}

#Preview {
    AppLockView()
}
