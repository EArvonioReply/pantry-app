//
//  Ingredient.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit

enum UnitOfMeasure {
    case kilograms
    case grams
    case ounce
    case pieces
    case litres
}

struct Ingredient: Identifiable {
    let id = UUID()
    var name: String
    var image: UIImage?
    var quantity: Double
    var unitOfMeasure: UnitOfMeasure
    var expiringDate: Date
    
    init(name: String, quantity: Double, unitOfMeasure: UnitOfMeasure, expiringDate: Date) {
        self.name = name
        self.quantity = quantity
        self.unitOfMeasure = unitOfMeasure
        self.expiringDate = expiringDate
    }
}

extension Ingredient {
    public static func getMockArray() -> [Ingredient] {
        return [
            Ingredient(name: "Mozzarella", quantity: 1.2, unitOfMeasure: .kilograms, expiringDate: Date()),
            Ingredient(name: "Olio", quantity: 0.5, unitOfMeasure: .litres, expiringDate: Date()),
            Ingredient(name: "Basilico", quantity: 8, unitOfMeasure: .pieces, expiringDate: Date())
        ]
    }
}
