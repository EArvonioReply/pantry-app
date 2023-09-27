//
//  IngredientViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

class IngredientViewControllerViewModel {
    let ingredient: Ingredient
    
    var name: String { ingredient.name }
    var image: UIImage { ingredient.image ?? UIImage(systemName: "fork.knife.circle.fill")! }
    var quantity: Double { ingredient.quantity }
    var unitOfMeasure: UnitOfMeasure { ingredient.unitOfMeasure }
    var expiringDate: Date { ingredient.expiringDate }
    
    // MARK: - IngredientViewControllerViewModel Init Methods
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    // MARK: - Utilities
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter.string(from: expiringDate).description
    }
    
}
