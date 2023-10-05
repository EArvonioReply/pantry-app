//
//  PantryViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//


import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

class PantryViewControllerViewModel {
    
    var ingredients: [Ingredient] = []
    
    var numberOfIngredients: Int {
        return ingredients.count
    }
    
    func loadData(handler: @escaping () -> Void) {
        IngredientManager.shared.getIngredients() { fetchedIngredients in
            self.ingredients = fetchedIngredients
            handler()
        }
    }
    
    func getIngredient(at position: Int) -> Ingredient {
        return ingredients[position]
    }
    
    func add(new ingredient: Ingredient, updateCollection: @escaping () -> Void, alertHandler: @escaping (UIAlertController) -> Void) {
        Task {
            do {
                let calendar = Calendar.current
                var alertedIngredient = ingredient
                if let tomorrow = calendar.date(byAdding: .hour, value: 24, to: Date()) {
                    if ingredient.expiringDate > tomorrow {
                        alertedIngredient.alertId = NotificationManager.shared.setNotification(ingredient: ingredient, handleNotification: alertHandler)
                    }
                }
                try await IngredientManager.shared.saveIngredient(alertedIngredient) { ingredient in
                    ingredients.append(ingredient)
                    updateCollection()
                }
            } catch {
                print("error in saving ingredient to the db: \(error)")
            }
        }
    }
    
    func removeIngredient(at indexPath: Int, updateCollection: @escaping () -> Void) {
        let ingredientToRemove = ingredients.remove(at: indexPath)
        updateCollection()
        NotificationManager.shared.removeNotification(identifiedBy: ingredientToRemove.alertId ?? "")
        IngredientManager.shared.removeIngredient(ingredientToRemove)
    }
    
}
