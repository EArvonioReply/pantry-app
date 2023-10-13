//
//  Constants.swift
//  pantry-app
//
//  Created by Marco Agizza on 10/10/23.
//

import Foundation

struct Constants {
    // MARK: Spoonacular API
    static let spoonacularScheme = "https"
    static let spoonacularHost = "api.spoonacular.com"
    static let spoonacularPort: Int? = nil
    static let spoonacularSearchPath = "recipes/findByIngredients"
    static let spoonacularFullURL = "https://api.spoonacular.com/"
    
    static let spoonacularAPIKey = "1b592e9c5bf349ff9500f77c0897a285"
    
    static let spoonacularNumberOfResults = 20
    static let spoonacularObviousIngredients = "water"
    
    // MARK: - UI Components
    static let buttonClickedOpacity: Float = 0.7
    static let buttonAtRestOpacity: Float = 1
}
