//
//  ConfirmView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 25/01/2024.
//

import SwiftUI

struct ConfirmView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    @Binding var firstPin: String
    @Binding var switchToTab: Bool
    @State private var secondPin = ""
    @State private var animateField: Bool = false
    


    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Text("Confirm Pin").font(.myTitleBIG) .frame(maxWidth: .infinity)
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle().frame(width: 20).foregroundStyle(appSettings.gradient())
                            .overlay {
                                if secondPin.count > index {
                                    Circle().frame(width: 20)
                                }
                            }
                    }
                }.padding(.top, 15) .frame(maxHeight: .infinity)
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
                
                GeometryReader { _ in
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                        ForEach(1...9, id: \.self) { number in
                            Button(action: {
                                if secondPin.count < 4 {
                                    secondPin.append("\(number)")
                                }
                            }, label: {
                                Text("\(number)").font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                            }).tint(.white)
                        }
                        
                        Button(action: {
                            if !secondPin.isEmpty {
                                secondPin.removeLast()
                            }
                        }, label: {
                            Image(systemName: "delete.backward")
                                .font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                        }).tint(.white)
                        
                        Button(action: {
                            if secondPin.count <= 4 {
                                secondPin.append("0")
                            }
                        }, label: {
                            Text("0").font(.myTitleBIG).frame(maxWidth: .infinity).padding(.vertical, 20) .contentShape(.rect)
                        }).tint(.white)
                        
                    }).frame(maxHeight: .infinity, alignment: .bottom)
                }
            }.offset(y: -35) .navigationBarBackButtonHidden()
                .onChange(of: secondPin) {
                    if secondPin.count == 4 {
                        if secondPin == firstPin {
                            appSettings.secretPin = secondPin
                            switchToTab = true
                            appSettings.lockState = .lock
                        } else {
                            animateField.toggle()
                            secondPin = ""
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            firstPin = ""
                            dismiss()
                        } label: {
                            Image(systemName: "arrowtriangle.left.fill")
                        }
                    }
                }
        }
    }
}
