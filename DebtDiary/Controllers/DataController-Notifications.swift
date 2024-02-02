//
//  DataController-Notifications.swift
//  DebtDiary
//
//  Created by Maciej Daszkiewicz on 01/02/2024.
//

import Foundation
import UserNotifications

extension DataController {
    func addReminder(for cash: Cash) async -> Bool {
        do {
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            
            switch settings.authorizationStatus {
            case .notDetermined:
                let success = try await requestNotifications()
                
                if success {
                    try await placeReminders(for: cash)
                } else {
                    return false
                }

            case .authorized:
                try await placeReminders(for: cash)

            default:
                return false
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func removeReminders(for cash: Cash) {
        let center = UNUserNotificationCenter.current()
        let id = cash.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func checkNotifications() async -> Bool {
        do {
            return try await requestNotifications()
        } catch {
            return false
        }
    }
    
    private func requestNotifications() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .sound])
    }
     
    private func placeReminders(for cash: Cash) async throws {
        let content = UNMutableNotificationContent()
        let title = cash.title.isEmpty ? "" : "- \"\(cash.title)\""
        content.title = "Reminder \(title)"
        content.sound = .default
        let lentOrNot = cash.lent ? "lent" : "borrowed"
        let toOrFrom = cash.lent ? "to" : "from"
        let person = cash.person.name.isEmpty ? "??" : cash.person.name
        let subtitle2 = "You \(lentOrNot) \(cash.amount)$ \(toOrFrom) \(person)"
        content.subtitle = subtitle2
        
        let components = Calendar.current.dateComponents([.calendar, .hour, .minute], from: cash.reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let id = cash.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await UNUserNotificationCenter.current().add(request)
    }
}
