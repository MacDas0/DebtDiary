//
//  AddSheet.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct AddSheet: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @State private var amount = ""
    @State private var person = ""
    @State private var title = ""
    @State private var tagString = ""
    @State private var lent = true
    @State private var tag: Tag?
    @State private var reminder = false
    @State private var date = Date.now
    @State private var showingNotificationsError = false
    @State private var creatingNewTag = false
    
    var body: some View {
        NavigationStack {
            VStack {
                lentOrNotView(lent: $lent)
                Spacer()
                CustomTextField(prompt:NSLocalizedString("Amount", comment: ""), text: $amount, image: "dollarsign", bottomPadding: true).keyboardType(.numberPad)
                Spacer()
                CustomTextField(prompt:NSLocalizedString("Person", comment: ""), text: $person, image: "person", bottomPadding: dataController.getPeople().filter({ $0.name != "" }).isEmpty)
                if !dataController.getPeople().filter({ $0.name != "" }).isEmpty {
                    PersonPickView(personName: $person)
                }
                Spacer()
                CustomTextField(prompt:NSLocalizedString("Title", comment: ""), text: $title, image: "shippingbox", bottomPadding: true)
                Spacer()
                if creatingNewTag {
                    CustomTextField(prompt:NSLocalizedString("Tag", comment: ""), text: $tagString, image: "tag", bottomPadding: false)
                }
                PickATagView(theTag: $tag, creatingNewTag: $creatingNewTag).padding(.bottom).padding(.bottom)
                Spacer()
                if reminder {
                    DatePicker(selection: $date) {
                        Image(systemName: "bell.fill").font(.title2) .foregroundStyle(appSettings.colorTheme)
                            .onTapGesture {
                                reminder.toggle()
                            }
                    }.fixedSize() .frame(height: 10)
                } else {
                    Button {
                        Task {
                            if await dataController.checkNotifications() {
                                reminder.toggle()
                            } else {
                                print("here")
                                showingNotificationsError = true
                            }
                        }
                        
                    } label: {
                        Image(systemName: "bell").font(.title2) .foregroundStyle(appSettings.colorTheme)
                    }.frame(height: 10)
                }
                Spacer()
                Spacer()
            }.background(Color.backgroundDark)
                .animation(.default, value: reminder)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let cash = dataController.FetchAndCreateCash(amount: Int(amount) ?? 0, person: person, tag: creatingNewTag ? tagString :  tag?.name ?? "", lent: lent, title: title, reminderEnabled: reminder, reminderTime: date)
                            updateReminder(cash: cash)
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark").accessibilityLabel("Create")
                        }
                    }
                }
                .alert("Notifications Disabled", isPresented: $showingNotificationsError) {
                    Button("Settings", action: showAppSettings)
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("If you wish to set reminders, please enable them in your device's settings.")
                }
        }
    }
    
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        openURL(settingsURL)
    }
    
    func updateReminder(cash: Cash) {
        dataController.removeReminders(for: cash)
        Task { @MainActor in
            if cash.reminderEnabled {
                let success = await dataController.addReminder(for: cash)
                if success == false {
                    cash.cashReminderEnabled = false
                    showingNotificationsError = true
                }
            }
        }
    }
}

struct CustomTextField: View {
    @EnvironmentObject var appSettings: AppSettings
    let prompt: String
    @Binding var text: String
    let image: String
    let bottomPadding: Bool
    var body: some View {
        HStack {
//            Image(systemName: image).bold() .frame(width: 30)
            VStack(spacing: 0) {
                TextField(prompt, text: $text).font(.myTitle).multilineTextAlignment(.center) .padding(5) .frame(maxWidth: .infinity)
                    .onReceive(text.publisher.collect()) { _ in
                        self.text = String(self.text.prefix(getStringMaxLength(forPrompt: prompt)))
                    }
                Rectangle().fill(appSettings.gradient()).frame(maxWidth: .infinity) .frame(height: 2) .padding(.horizontal)
            }
        }.padding(.bottom, bottomPadding ? 15 : 0)
    }
    
    func getStringMaxLength(forPrompt prompt: String) -> Int {
        if prompt == "Amount" {
            return 10
        } else if prompt == "Person"{
            return 20
        } else if prompt == "Title" {
            return 30
        } else {
            return 20
        }
    }
}

struct PersonPickView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var appSettings: AppSettings
    @State var thePerson: Person?
    @Binding var personName: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(dataController.getPeople().filter { $0.name != "" }) { person in
                    Button(action: {
                        if thePerson == person {
                            thePerson = nil
                            personName = ""
                        } else {
                            thePerson = person
                            personName = person.name
                        }
                    }) {
                        Text(LocalizedStringKey(person.name)).font(.myMidMedium)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .background(Color.backgroundDark)
                            .foregroundColor(Color.white.opacity(person == thePerson ? 1 : 0.6))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(person == thePerson ? 1 : 0.5), lineWidth: person == thePerson ? 2 : 1))
                            .accessibilityHint("category")
                    }.sensoryFeedback(.selection, trigger: thePerson)
                        .contextMenu {
                            Button("Delete") {
                                if person.cash.isEmpty {
                                    dataController.delete(person)
                                } else {
                                    for cash in person.cash {
                                        let emptyPerson = dataController.FetchOrCreatePerson(name: "")
                                        cash.person = emptyPerson
                                    }
                                    dataController.delete(person)
                                }
                            }
                        }
                }
            }.padding(.horizontal) .padding(.vertical, 5)
                .onChange(of: personName) {
                    if personName != thePerson?.name {
                        thePerson = nil
                    }
                    if dataController.getPeople().contains(where: { $0.name == personName }) {
                        thePerson = dataController.getPeople().first(where: { $0.name == personName })
                    }
                }
        }
    }
}

struct lentOrNotView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Binding var lent: Bool
    var body: some View {
        HStack {
            Spacer()
            Button {
                lent = true
            } label: {
                Text("Lend").padding() .frame(minWidth: 110) .opacity(lent ? 1 : 0.5) .font(.myTitle) .background(Color.backgroundDark) .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) .fixedSize(horizontal: true, vertical: false) .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous) .stroke(appSettings.gradient().opacity(lent ? 1 : 0.6), lineWidth: lent ? 2 : 1)) .accessibilityLabel("tag as lent")
            }.sensoryFeedback(.selection, trigger: lent)
            Spacer()
            Button {
                lent = false
            } label: {
                Text("Borrow").padding().frame(minWidth: 110) .opacity(lent ? 0.5 : 1) .font(.myTitle) .background(Color.backgroundDark) .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) .fixedSize(horizontal: true, vertical: false) .overlay(RoundedRectangle(cornerRadius : 10, style: .continuous).stroke(appSettings.gradient().opacity(lent ? 0.6 : 1), lineWidth: lent ? 1 : 2)) .accessibilityLabel("tag as borrowed") 
            }.sensoryFeedback(.selection, trigger: lent)
            Spacer()
        } .padding(.horizontal) .padding(.horizontal)
    }
}

struct PickATagView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var dataController: DataController
    @Binding var theTag: Tag?
    @Binding var creatingNewTag: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(dataController.getTags().filter { $0.name != "" }) { tag in
                    Button(action: {
                        if theTag == tag {
                            theTag = nil
                        } else {
                            creatingNewTag = false
                            theTag = tag
                        }
                    }) {
                        Text(LocalizedStringKey(tag.name)).font(.myMidMedium)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .background(Color.backgroundDark)
                            .foregroundColor(Color.white.opacity(tag == theTag ? 1 : 0.6))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(tag == theTag ? 1 : 0.5), lineWidth: tag == theTag ? 2 : 1))
                            .accessibilityHint("category")
                    }.sensoryFeedback(.selection, trigger: theTag)
                        .contextMenu {
                            Button("Delete") {
                                if tag.cash.isEmpty {
                                    dataController.delete(tag)
                                } else {
                                    for cash in tag.cash {
                                        let emptyTag = dataController.FetchOrCreateTag(name: "")
                                        cash.tag = emptyTag
                                    }
                                    dataController.delete(tag)
                                }
                            }
                        }
                }
                Button {
                    creatingNewTag.toggle()
                    theTag = nil
                } label: {
                    Image(systemName: "plus").fontWeight(.heavy)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 16)
                        .background(Color.backgroundDark)
                        .foregroundColor(Color.white.opacity(creatingNewTag ? 1 : 0.6))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(creatingNewTag ? 1 : 0.5), lineWidth: creatingNewTag ? 2 : 1))
                }
                Spacer()
            }.padding(.horizontal) .padding(.top, 5)
        }
    }
}
