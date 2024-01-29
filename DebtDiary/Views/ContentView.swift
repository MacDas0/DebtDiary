//
//  ContentView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State private var switchToTab = false

    var body: some View {
        Group {
            switch appSettings.lockState {
            case .noLock:
                Tab()
            case .lock:
                if switchToTab {
                    Tab()
                } else {
                    LockView(switchToTab: .constant(true), lockType: .both, lockPin: appSettings.secretPin, isEnabled: true, lockWhenAppGoesBackground: false, overRideString: nil) {
                        Tab()
                    }
                }
            case .newLock:
                CreatePinView(switchToTab: $switchToTab)
            case .editLock:
                    LockView(switchToTab: $switchToTab, lockType: .number, lockPin: appSettings.secretPin, isEnabled: true, lockWhenAppGoesBackground: false, overRideString: "Enter Old Pin") {
                        CreatePinView(switchToTab: $switchToTab)
                    }
            case .removeLock:
                LockView(switchToTab: $switchToTab, lockType: .number, lockPin: appSettings.secretPin, isEnabled: true, lockWhenAppGoesBackground: false, overRideString: nil) {
                    Tab()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
