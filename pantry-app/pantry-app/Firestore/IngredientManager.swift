//
//  IngredientManager.swift
//  pantry-app
//
//  Created by Marco Agizza on 30/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - IngredientManager

class IngredientManager {
    
    // MARK: - Shared Instance
    static let shared: IngredientManager = IngredientManager()
    private let ingredientCollection = Firestore.firestore().collection("ingredients")
    
    // MARK: - Firestore Encoder and Decoder
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
    
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    
    // MARK: - IngredientManager Init Method
    
    private init() { }
    
    private func ingredientDocument(identifiedBy id: String) -> DocumentReference {
        ingredientCollection.document(id)
    }
}

// MARK: - Create and Fetch requests with encoder and decoder

extension IngredientManager {
    
    func saveIngredient(_ ingredient: Ingredient) async throws {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        try ingredientDocument(identifiedBy: ingredient.id).setData(from: ingredient, merge: false, encoder: encoder)
    }
    
    func getIngredient(ingredientID: String) async throws -> Ingredient {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try await ingredientDocument(identifiedBy: ingredientID).getDocument(as: Ingredient.self, decoder: decoder)
    }
}

// MARK: - Create and Fetch requests with dictionaries

extension IngredientManager {
    func createNewIngredientDict(_ ingredient: Ingredient) async throws {
        var ingredientData: [String:Any] = [
            "name": ingredient.name,
            "quantity": ingredient.quantity,
            "expiring_date": Timestamp(date: ingredient.expiringDate)
        ]
        if let photoUrl = ingredient.photoUrl {
            ingredientData["photo_url"] = photoUrl
        }
        try await ingredientDocument(identifiedBy: ingredient.id).setData(ingredientData, merge: false)
    }
    
    func getIngredientDict(ingredientID: String) async throws -> Ingredient {
        let snapshot = try await ingredientDocument(identifiedBy: ingredientID).getDocument()
        guard let data = snapshot.data(), let id = data["ingredient_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        
        let name = data["name"] as? String
        let quantity = data["quantity"] as? Double
        let expiringDate = data["expiring_date"] as? Date
        let photoUrl = data["photo_url"] as? String
        
        return Ingredient(id: id, name: name ?? "", quantity: quantity ?? 0.0, expiringDate: expiringDate ?? Date(), photoUrl: photoUrl)
    }
}
