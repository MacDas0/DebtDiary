//
//  MailView.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 27/01/2024.
//

import SwiftUI
import UIKit
import MessageUI

import Foundation

struct ExampleData: Encodable, Identifiable {
    let id = UUID()
    let name: String
    let image: String
    
    static var examples: [ExampleData] {
        [
            ExampleData(name: "Basketball", image: "🏀"),
            ExampleData(name: "Soccer", image: "⚽️"),
            ExampleData(name: "Rugby", image: "🏉"),
            ExampleData(name: "Football", image: "🏈"),
            ExampleData(name: "Tennis", image: "🎾"),
            ExampleData(name: "Baseball", image: "⚾️"),
            ExampleData(name: "Volleyball", image: "🏐"),
            ExampleData(name: "Pool", image: "🎱")
        ]
    }
    
    static var data: Data? {
        try? JSONEncoder().encode(examples)
    }
}

// Credit for this struct goes to https://swiftuirecipes.com/blog/send-mail-in-swiftui

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentation
  @Binding var supportEmail: SupportEmail
  let callback: MailViewCallback

  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentation: PresentationMode
    @Binding var data: SupportEmail
    let callback: MailViewCallback

    init(presentation: Binding<PresentationMode>,
         data: Binding<SupportEmail>,
         callback: MailViewCallback) {
      _presentation = presentation
      _data = data
      self.callback = callback
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      if let error = error {
        callback?(.failure(error))
      } else {
        callback?(.success(result))
      }
      $presentation.wrappedValue.dismiss()
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(presentation: presentation, data: $supportEmail, callback: callback)
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
    let mvc = MFMailComposeViewController()
    mvc.mailComposeDelegate = context.coordinator
    mvc.setSubject(supportEmail.subject)
    mvc.setToRecipients([supportEmail.toAddress])
    mvc.setMessageBody(supportEmail.body, isHTML: false)
      mvc.addAttachmentData(supportEmail.data!, mimeType: "text/plain", fileName: "\(Bundle.main.displayName).json")
    mvc.accessibilityElementDidLoseFocus()
    return mvc
  }

  func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                              context: UIViewControllerRepresentableContext<MailView>) {
  }

  static var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }
}
