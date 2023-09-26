//
//  PantryViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import MVVMKit

class PantryViewControllerViewModel {
    var ingredients: [Ingredient] = []
    
    var numberOfIngredients: Int {
        return ingredients.count
    }
    
    func loadData() {
        ingredients = Ingredient.getMockArray()
    }
    
    func getIngredient(at position: Int) -> Ingredient {
        return ingredients[position]
    }
}
