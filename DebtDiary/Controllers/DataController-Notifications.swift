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
        content.title = cash.title
        content.sound = .default
        let subtitle = cash.person.name+" - "+String(cash.amount)+"$"
        content.subtitle = subtitle
        
        let components2 = Calendar.current.dateComponents([.calendar, .hour, .minute], from: cash.reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components2, repeats: false)
//        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let id = cash.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        return try await UNUserNotificationCenter.current().add(request)
    }
}
