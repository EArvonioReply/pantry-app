//
//  FirstStepViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

class FirstStepViewControllerViewModel {
    var ingredient: Ingredient
    let unitsOfMeasure = ["litres", "kilograms", "grams", "pieces"]
    let defaultValueRow = 3
    
    init() {
        self.ingredient = Ingredient()
    }
}
