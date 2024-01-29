//
//  SupportEmail.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 27/01/2024.
//

import UIKit
import SwiftUI

struct SupportEmail {
    let toAddress: String
    var subject: String
    var mainText: String
    var data: Data?
    var body: String {"""
        \(mainText)

        --------------------------------------------
        Application Name: \(Bundle.main.displayName)
        iOS: \(UIDevice.current.systemVersion)
        Device Mode: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
    
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto: \(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """
                )
            }
        }
    }
}
