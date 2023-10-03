//
//  PantryViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UserNotifications
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import CodableFirebase
import MVVMKit

class PantryViewControllerViewModel {
    
    var ingredients: [Ingredient] = []
    
    var numberOfIngredients: Int {
        return ingredients.count
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func loadData(handler: @escaping () -> Void) {
        IngredientManager.shared.getIngredients() { fetchedIngredients in
            self.ingredients = fetchedIngredients
            handler()
        }
    }
    
    func getIngredient(at position: Int) -> Ingredient {
        return ingredients[position]
    }
    
    func add(new ingredient: Ingredient, handler: @escaping (UIAlertController) -> Void) {
        Task {
            do {
                try await IngredientManager.shared.saveIngredient(ingredient) { ingredient in
                    ingredients.append(ingredient)
                    setNotification(ingredient: ingredient, handler: handler)
                }
            } catch {
                print("error in saving ingredient to the db: \(error)")
            }
        }
    }
    
    // MARK: - Local notificiation management
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            if permissionGranted {
                print("Permission granted!")
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
            default:
                return
            }
        }
    }
    
    func setNotification(ingredient: Ingredient, handler: @escaping (UIAlertController) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                
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
                var expiringDateComponents = calendar.dateComponents([.hour, .minute], from: ingredient.expiringDate)
                guard let dayBeforeExpiringDate = calendar.date(byAdding: .day, value: -1, to: ingredient.expiringDate) else {
                    print("Error in making dayBeforeExpiringDate")
                    return
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
                let ac = UIAlertController(title: "Notification Scheduled", message: "You will be reminded of the product expiration on \(self.formattedDate(date: dayBeforeExpiringDate)) at \(hour):\(minute)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok, thanks!", style: .default, handler: { (_) in}))
                handler(ac)
            }
            
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: date)
    }
    
}
