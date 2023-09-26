//
//  PantryViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

class PantryViewControllerViewModel {
    var ingredients: [Ingredient] = []
    
    var numberOfIngredients: Int {
        return ingredients.count
    }
    
    func loadData() {
        let debugIngredientsNames = ["pane", "pomodoro", "patata", "banana", "mela", "aglio", "olio", "lattuga"]
        debugIngredientsNames.forEach { name in
            let ingredient = Ingredient(name: name, quantity: 2, unitOfMeasure: .kilograms, expiringDate: Date())
            ingredients.append(ingredient)
        }
    }
    
    func getIngredient(at position: Int) -> Ingredient {
        return ingredients[position]
    }
}
