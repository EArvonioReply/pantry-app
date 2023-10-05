//
//  NotificationManager.swift
//  pantry-app
//
//  Created by Marco Agizza on 04/10/23.
//

import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let defaults = UserDefaults.standard
    
    // MARK: - Local notificiation management
    
    func setNotification(ingredient: Ingredient, handleNotification: @escaping (UIAlertController) -> Void) -> String {
        if defaults.bool(forKey: "notificationsPermissionGranted") {
            let identifier = UUID().uuidString
            let title = "Expiration alert"
            let body = "You have \(ingredient.quantity) \(ingredient.unitOfMeasure) of \(ingredient.name) to use by tomorrow!"
            let minute = 40
            let hour = 10
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let calendar = Calendar.current
            guard let dayBeforeExpiringDate = calendar.date(byAdding: .day, value: -1, to: ingredient.expiringDate) else {
                print("Error in making dayBeforeExpiringDate")
                return ""
            }
            var dateComponents = calendar.dateComponents([.day, .month, .year], from: dayBeforeExpiringDate)
            dateComponents.minute = minute
            dateComponents.hour = hour
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                if(error != nil) {
                    print("Error " + error.debugDescription)
                    return
                } else {
                    print("tutto ok")
                }
            }
            let alertController = UIAlertController(title: "Notification Scheduled", message: "You will be reminded of the product expiration on \(self.formattedDate(date: dayBeforeExpiringDate)) at \(hour):\(minute)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok, thanks!", style: .default, handler: { (_) in}))
            handleNotification(alertController)
            
            return identifier
        }
        return ""
    }
    
    func removeNotification(identifiedBy id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if permissionGranted {
                self.defaults.set(true, forKey: "notificationsPermissionGranted")
            } else {
                self.defaults.set(false, forKey: "notificationsPermissionGranted")
            }
        }
    }
    
    func checkForPermission(handler: @escaping (UIAlertController) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationAuthorization()
            case .denied:
                let title = "Expiring reminder"
                let message = "To use this feature you must enable notifications in settings"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl) { (_) in }
                    }
                }
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (_) in})
                
                alertController.addAction(goToSettings)
                alertController.addAction(cancel)
                
                handler(alertController)
            case .authorized:
                self.defaults.set(true, forKey: "notificationsPermissionGranted")
            default:
                return
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
    }
}
