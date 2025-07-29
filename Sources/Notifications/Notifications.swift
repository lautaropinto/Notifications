//
//  Notifications.swift
//  Kaizenth
//
//  Created by Lautaro Pinto on 12/5/24.
//

import Foundation
import UserNotifications
import OSLog

private let logger = Logger(
    subsystem: "Notifications",
    category: "Notifications Package"
)

public final class Notifications {
    
    public static func requestNotificationPermission(options: UNAuthorizationOptions = []) async throws -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let result = try await notificationCenter.requestAuthorization(
            options: options
        )
        
        return result
    }
    
    public static func addSingleNotification(
        notificationID: UUID,
        title: String,
        subtitle: String,
        day: Int,
        month: Int,
        year: Int,
        hour: Int,
        minute: Int = 0
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let date: DateComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)

        let request = UNNotificationRequest(
            identifier: notificationID.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
        logger.info("Single notification added at \(hour):\(minute).")
    }
    
    //MARK: - Notifications
    public static func addRepeatingNotification(
        notificationID: UUID,
        title: String,
        subtitle: String,
        hour: Int,
        minute: Int
    ) async throws -> Bool {
        let allowed = try await Notifications.requestNotificationPermission(options: [.alert, .badge, .sound])
        
        if allowed {
            addNotification(
                notificationID: notificationID,
                title: title,
                subtitle: subtitle,
                hour: hour,
                minute: minute
            )
        }
        logger.info("Repeating notification permissions: \(allowed).")
        return allowed
    }
    
    static private func addNotification(
        notificationID: UUID,
        title: String,
        subtitle: String,
        hour: Int,
        minute: Int
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let date: DateComponents = DateComponents(hour: hour, minute: minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(
            identifier: notificationID.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
        logger.info("Notification added at \(hour):\(minute) with ID: \(notificationID.uuidString)")
    }

    public static func removeNotifications(with id: UUID) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        logger.info("Notification \(id.uuidString) removed.")
    }
}
