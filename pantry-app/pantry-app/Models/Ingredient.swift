//
//  Ingredient.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - UnitOfMeasure

enum UnitOfMeasure: Decodable {
    case litres
    case kilograms
    case grams
    case pieces
}

// MARK: - Ingredient

struct Ingredient: Codable {
    
    var id: String
    var name: String
    var quantity: Double
    var expiringDate: Date
    var photoUrl: String?
    //var unitOfMeasure: UnitOfMeasure
    
    // MARK: - Ingredient Init Methods
    
    init() {
        id = UUID().uuidString
        name = ""
        quantity = 0.0
        expiringDate = Date()
        //unitOfMeasure = .pieces
    }
    
    init(id: String, name: String, quantity: Double, expiringDate: Date, photoUrl: String?) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.expiringDate = expiringDate
        self.photoUrl = photoUrl
    }
    
}
