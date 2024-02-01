//
//  ColorManager.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI
import LocalAuthentication

class AppSettings: ObservableObject {
    
    // APPEARANCE
    @Published var colorTheme: Color = Color.customGreen {
        didSet {
            colorName = Color.name(for: colorTheme)
            saveColorToUserDefaults()
        }
    }
    @Published var colorName: String = "customGreen"
        
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
    // PREFERENCES
    static let allCurrencies = Bundle.main.decode([Currency].self, from: "Currency.json")
    @Published var selectedCurrency: Currency?
    func loadCurrencies()  {
        selectedCurrency = AppSettings.allCurrencies.first(where: { $0.code == currency })
    }
    @Published var currency = "USD" {
        didSet {
            saveCurrencyToUserDefaults()
        }
    }
    
    let supportedLanguages = ["Polish", "English"]
    @Published var language = "English"
    
    @Published var UseHaptics = true
    
    // LOCK
    @Published var secretPin = "" {
        didSet {
            savePinToUserDefaults()
        }
    }

    func updateLockType() {
        if lockState == .noLock {
            authenticate()
            lockState = .newLock
        } else if lockState == .lock {
            lockState = .removeLock
        }
    }
    func authenticate() {
    let context = LAContext()
    var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
    
    var isBiometricAvailable: Bool {
    let context = LAContext()
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
}
    enum LockState {
        case noLock, lock, newLock, editLock, removeLock
    }
    @Published var lockState: LockState = .noLock {
        willSet {
            if lockState == .lock || lockState == .noLock {
                oldLockState = lockState
            }
        }
        didSet {
            if lockState == .lock || lockState == .noLock {
                saveLockStateToUserDefaults()
            }
        }
    }
    @Published var oldLockState: LockState = .noLock
    
    init() {
        loadSettings()
    }
    
    private func saveLockStateToUserDefaults() {
        UserDefaults.standard.set(lockState.rawValue, forKey: "lockState")
    }
    private func savePinToUserDefaults() {
        UserDefaults.standard.set(secretPin, forKey: "pin")
    }
    
    private func saveCurrencyToUserDefaults() {
        UserDefaults.standard.set(currency, forKey: "currency")
    }
    
    private func saveColorToUserDefaults() {
        colorTheme.save(to: UserDefaults.standard, withKey: "color")
    }
    
    func loadSettings() {
        if let savedLockState = UserDefaults.standard.value(forKey: "lockState") as? String,
           let state = LockState(rawValue: savedLockState) {
            lockState = state
            print("-------------------\(state)")
        }
        if let retrievedColor = Color.load(from: UserDefaults.standard, withKey: "color") {
            colorTheme = retrievedColor
        }
        
        secretPin = UserDefaults.standard.string(forKey: "pin") ?? ""
        currency =  UserDefaults.standard.string(forKey: "currency") ?? "USD"
    }
}

extension AppSettings.LockState: RawRepresentable {
    typealias RawValue = String

    init?(rawValue: RawValue) {
        switch rawValue {
        case "noLock":
            self = .noLock
        case "lock":
            self = .lock
        default:
            return nil
        }
    }

    var rawValue: RawValue {
        switch self {
        case .noLock:
            return "noLock"
        case .lock:
            return "lock"
        case .newLock:
            return "noLock"
        case .editLock:
            return "Lock"
        case .removeLock:
            return "Lock"
        }
    }
}
