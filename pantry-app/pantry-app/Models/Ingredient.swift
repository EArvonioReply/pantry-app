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
    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case quantity = "quantity"
//        case expiringDate = "expiring_date"
//        case photoUrl = "photo_url"
//    }
    
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
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.quantity = try container.decode(Double.self, forKey: .quantity)
//        self.expiringDate = try container.decode(Date.self, forKey: .expiringDate)
//        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.id, forKey: .id)
//        try container.encode(self.name, forKey: .name)
//        try container.encode(self.quantity, forKey: .quantity)
//        try container.encode(self.expiringDate, forKey: .expiringDate)
//        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
//    }
    
}
