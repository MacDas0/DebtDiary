//
//  LockView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 24/01/2024.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    @Binding var switchToTab: Bool
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    
    let overRideString: String?
    
    @ViewBuilder var content: Content
    var forgotPin: () -> () = {  }
    
    @State private var pin: String = ""
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    @State private var removeLock = false
    @State private var showFaceIDAlert = false
    
    @Environment(\.scenePhase) private var phase
    @EnvironmentObject var appSettings: AppSettings
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content.frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                
                ZStack {
                    Rectangle().ignoresSafeArea().foregroundStyle(.black)
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        NumberPadPinView()
                    } else {
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
        }
    }
    
    private func unlockView() {
        let context = LAContext()
        Task {
            if appSettings.isBiometricAvailable {
                if let result = try? await
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the App"), result {
                    print("Unlocked")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            noBiometricAccess = !appSettings.isBiometricAvailable
        }
    }
    
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    if !switchToTab {
                        switchToTab = true
                        appSettings.lockState = appSettings.oldLockState
                    }
                } label: {
                    Image(systemName: "xmark").opacity(switchToTab ? 0 : 1).font(.title3)
                }
                Spacer()
                Text(overRideString != nil ? overRideString! : "Enter Pin").font(.myTitleBIG) .frame(maxWidth: .infinity) .offset(x: -12)
                Spacer()
            }
            HStack(spacing: 20) {
                ForEach(0..<4, id: \.self) { index in
                    Circle().frame(width: 20).foregroundStyle(appSettings.gradient())
                        .overlay {
                            if pin.count > index {
//                                let index = pin.index(pin.startIndex, offsetBy: index)
//                                let string = String(pin[index])
                                
                                Circle().frame(width: 20)
                            }
                        }
                    
                }
            }.padding(.top, 15)
                .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                    content
                        .offset(x: value)
                }, keyframes: { _ in
                    KeyframeTrack {
                        CubicKeyframe(30, duration: 0.07)
                        CubicKeyframe(-30, duration: 0.07)
                        CubicKeyframe(20, duration: 0.07)
                        CubicKeyframe(-20, duration: 0.07)
                        CubicKeyframe(0, duration: 0.07)
                    }
                })
//                .overlay(alignment: .bottomTrailing) {
//                    Button("Forgot Pin?", action: forgotPin).font(.myMini) .foregroundStyle(.white) . offset(y: 40)
//                } 
                .frame(maxHeight: .infinity)
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)").font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                        }).tint(.white)
                    }
                    
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                    }).tint(.white)
                    
                    Button(action: {
                        if pin.count <= 4 {
                            pin.append("0")
                        }
                    }, label: {
                        Text("0").font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                    }).tint(.white)
                    
                    Button(action: {
                        unlockView()
                        if noBiometricAccess { showFaceIDAlert.toggle() }
                    }, label: {
                        Image(systemName: "faceid").font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                    }).tint(.white)
                    
                }).frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    removeLock.toggle()
                    if lockPin == pin {
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            pin = ""
                            noBiometricAccess = !appSettings.isBiometricAvailable
                        }
                    } else {
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
            .onChange(of: removeLock) {
                if overRideString == nil {
                    if appSettings.lockState == .removeLock {
                        appSettings.secretPin = ""
                        appSettings.lockState = .noLock
                    }
                }
            }
            .alert(isPresented: $showFaceIDAlert) {
                 Alert (title: Text("FaceID access required"),
                        message: Text("Go to Settings?"),
                        primaryButton: .default(Text("Settings"), action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }),
                       secondaryButton: .default(Text("Cancel")))
                    }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
}

enum LockType: String {
    case biometric = "Bio Metric Auth"
    case number = "Custom Number Lock"
    case both = "First preference will be biometric, and if it's not available, it will go for number lock."
}

#Preview {
    ContentView()
}
