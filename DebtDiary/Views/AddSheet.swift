//
//  AddSheet.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 23/01/2024.
//

import SwiftUI

struct AddSheet: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var amount = ""
    @State private var person = ""
    @State private var title = ""
    @State private var lent = true
    @State private var tag: Tag?

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                lentOrNotView(lent: $lent)
                Spacer()
                CustomTextField(prompt:"Amount", text: $amount, image: "dollarsign").keyboardType(.numberPad)
                Spacer()
                CustomTextField(prompt:"Person", text: $person, image: "person")
                Spacer()
                CustomTextField(prompt:"Title", text: $title, image: "shippingbox")
                Spacer()
                PickATagView(theTag: $tag) .padding(.bottom) .padding(.bottom) .padding(.bottom)
                Spacer()
            }.background(Color.backgroundDark)
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
                        dataController.createCash(amount: Int(amount) ?? 0, person: person, tag: tag?.name ?? "---", lent: lent, title: title)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
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
    var body: some View {
        HStack {
//            Image(systemName: image).bold() .frame(width: 30)
            VStack(spacing: 0) {
                TextField(prompt, text: $text).font(.myTitle).multilineTextAlignment(.center) .padding(10) .frame(maxWidth: .infinity)
                Rectangle().fill(appSettings.gradient()).frame(maxWidth: .infinity) .frame(height: 2) .padding(.horizontal)
            }
        } .padding(.bottom)
    }
}

struct lentOrNotView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Binding var lent: Bool
    var body: some View {
        HStack {
            Spacer()
            Text("LEND").padding() .frame(minWidth: 110) .opacity(lent ? 1 : 0.5) .font(.myTitle) .background(Color.backgroundDark) .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) .fixedSize(horizontal: true, vertical: false) .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous) .stroke(appSettings.gradient().opacity(lent ? 1 : 0.6), lineWidth: lent ? 2 : 1)) .onTapGesture { lent = true }
            Spacer()
            Text("BORROW").padding().frame(minWidth: 110) .opacity(lent ? 0.5 : 1) .font(.myTitle) .background(Color.backgroundDark) .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) .fixedSize(horizontal: true, vertical: false) .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(lent ? 0.6 : 1), lineWidth: lent ? 1 : 2)) .onTapGesture { lent = false }
            Spacer()
        } .padding() .padding()
    }
}

struct PickATagView: View {
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var dataController: DataController
    @Binding var theTag: Tag?
    @State private var firstTags = [Tag]()
    @State private var secondTags = [Tag]()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(firstTags, id: \.self) { tag in
                    Button(action: {
                        if theTag == tag {
                            theTag = nil
                        } else {
                            theTag = tag
                        }
                    }) {
                        Text(tag.name).font(.myMidMedium)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .background(Color.backgroundDark)
                            .foregroundColor(Color.white.opacity(tag == theTag ? 1 : 0.6))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(tag == theTag ? 1 : 0.7), lineWidth: tag == theTag ? 2 : 1))
                    }
                }
                Spacer()
            }.padding(.horizontal) .padding(.vertical, 5)
            HStack(spacing: 10) {
                ForEach(secondTags, id: \.self) { tag in
                    Button(action: {
                        if theTag == tag {
                            theTag = nil
                        } else {
                            theTag = tag
                        }
                    }) {
                        Text(tag.name).font(.myMidMedium)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 16)
                            .background(Color.backgroundDark)
                            .foregroundColor(Color.white.opacity(tag == theTag ? 1 : 0.6))
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(appSettings.gradient().opacity(tag == theTag ? 1 : 0.7), lineWidth: tag == theTag ? 2 : 1))
                    }
                }
                Spacer()
            }.padding(.horizontal) .padding(.vertical, 5)
        }
            .onAppear {
                for (index, tag) in dataController.tags.enumerated() {
                    if index % 2 == 0 {
                        firstTags.append(tag)
                    } else {
                        secondTags.append(tag)
                    }
                }
            }
    }
}
