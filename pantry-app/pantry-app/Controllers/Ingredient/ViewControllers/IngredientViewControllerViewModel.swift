//
//  IngredientViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

class IngredientViewControllerViewModel {
    let ingredient: Ingredient
    var recipes = [Recipe]()
    
    var name: String { ingredient.name }
    var photoUrl: String? { ingredient.photoUrl }
    var quantity: Double { ingredient.quantity }
    var unitOfMeasure: UnitOfMeasure { ingredient.unitOfMeasure }
    var expiringDate: Date { ingredient.expiringDate }
    var numberOfRecipes: Int {recipes.count}
    
    // MARK: - IngredientViewControllerViewModel Init Methods
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
        
    }
    
    // MARK: - Utilities
    
    func loadData(handler: @escaping () -> Void) {
        var availableIngredients = "water,\(name)"
        
        let parameters = [
            "apiKey" : "1b592e9c5bf349ff9500f77c0897a285",
            "ingredients" : availableIngredients
        ]
        Task {
            do {
                try await APIHandler<Recipe>.getRecipe(by: parameters) { recipesList, apiError in
                    if let recipesList = recipesList {
                        recipesList.forEach { recipe in
                            self.recipes.append(recipe)
                        }
                        handler()
                    } else if let error = apiError {
                        print("handle error: \(error)")
                    }
                }
            } catch {
                print("molto male")
            }
        }
        
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter.string(from: expiringDate).description
    }
    
    func getRecipe(at index: Int) -> Recipe {
        return recipes[index]
    }
    
}
