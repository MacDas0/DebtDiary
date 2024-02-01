//
//  ContactUsView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 27/01/2024.
//

import SwiftUI

struct ContactUsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @EnvironmentObject var appSettings: AppSettings
    @State private var askForAttachment = false
    @State private var showEmail = false
    @State private var email = SupportEmail(toAddress: "debtjournal@outlook.com", subject: "", mainText: "")
    @State private var titleText = ""
    @State private var bodyText = ""
    @State private var emailType = "Other"

    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Picker("", selection: $emailType) {
                    Text("Suggest Feature").tag("Suggest Feature")
                    Text("Report Bug").tag("Report Bug")
                    Text("Other").tag("Other")
                }.pickerStyle(.segmented) .accessibilityIdentifier("Type Picker")
                VStack(spacing: 15) {
                    TextField("Title", text: $titleText, axis: .vertical).font(.myTitleBIG).accessibilityLabel("Title")
                    TextField("...", text: $bodyText, axis: .vertical).font(.myTitle).accessibilityLabel("Content")
                }
                Spacer()
            }.padding() .background(Color.backgroundDark)
                .sheet(isPresented: $showEmail) {
                    MailView(supportEmail: $email) { result in
                        switch result {
                        case .success:
                            print("Email sent")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    .onDisappear { dismiss() }
                }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        email.data = ExampleData.data
                        if !titleText.isEmpty {
                            email.subject = titleText
                            email.subject.append("  (\(emailType))")
                        } else {
                            email.subject = (emailType)
                        }
                        email.mainText = bodyText
                        if MailView.canSendMail {
                            showEmail.toggle()
                        } else {
                            print("cant show email")
                        }
                    } label: {
                        Image(systemName: "paperplane").font(.myTitle)
                    }
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
    ContactUsView()
}


