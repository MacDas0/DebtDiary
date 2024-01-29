//
//  CreatePinView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 25/01/2024.
//

import SwiftUI

struct CreatePinView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    @State private var pin = ""
    @State private var confirmPin = false
    @Binding var switchToTab: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Text("Create Pin").font(.myTitleBIG) .frame(maxWidth: .infinity)
                HStack(spacing: 20) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle().frame(width: 20).foregroundStyle(appSettings.gradient())
                            .overlay {
                                if pin.count > index {
                                    Circle().frame(width: 20)
                                }
                            }
                    }
                }.padding(.top, 15) .frame(maxHeight: .infinity)
                
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
                        
                    }).frame(maxHeight: .infinity, alignment: .bottom)
                }
                .toolbar { ToolbarItem(placement: .principal) { Text("") } }
                .onChange(of: pin) {
                    if pin.count == 4 {
                        confirmPin = true
                    }
                }
            }.offset(y: -35)
            .navigationDestination(isPresented: $confirmPin) {
                ConfirmView(firstPin: $pin, switchToTab: $switchToTab)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        switchToTab = true
                        appSettings.lockState = appSettings.oldLockState
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}
