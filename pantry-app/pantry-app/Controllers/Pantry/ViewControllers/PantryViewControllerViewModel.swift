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
    
    func add(new ingredient: Ingredient, handler: @escaping (UIAlertController) -> Void) {
        Task {
            do {
                var alertedIngredient = ingredient
                alertedIngredient.alertId = NotificationManager.shared.setNotification(ingredient: ingredient, handleNotification: handler)
                try await IngredientManager.shared.saveIngredient(alertedIngredient) { ingredient in
                    ingredients.append(ingredient)
                }
            } catch {
                print("error in saving ingredient to the db: \(error)")
            }
        }
    }
    
}
