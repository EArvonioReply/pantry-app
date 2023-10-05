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
    private let database = Firestore.firestore()
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
    
    func saveIngredient(_ ingredient: Ingredient, handler: (Ingredient) -> Void ) async throws {
        let encoder = Firestore.Encoder()
        
        // try ingredientDocument(identifiedBy: ingredient.id).setData(from: ingredient, merge: false, encoder: encoder)
        let documentReference = try ingredientCollection.addDocument(from: ingredient)
        var ingredientToPass = ingredient
        ingredientToPass.id = documentReference.documentID
        
        try ingredientDocument(identifiedBy: documentReference.documentID).setData(from: ingredientToPass, encoder: encoder)
        handler(ingredientToPass)
    }
    
    func removeIngredient(_ ingredient: Ingredient) {
        guard let ingredientId = ingredient.id else {return}
        
        ingredientCollection.document(ingredientId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getIngredient(ingredientID: String) async throws -> Ingredient {
        let decoder = Firestore.Decoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        
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
        if let alertId = ingredient.alertId {
            ingredientData["alert_id"] = alertId
        }
        
        switch ingredient.unitOfMeasure {
        case .litres:
            ingredientData["unit_of_measure"] = "litres"
        case .kilograms:
            ingredientData["unit_of_measure"] = "kilograms"
        case .grams:
            ingredientData["unit_of_measure"] = "grams"
        case .pieces:
            ingredientData["unit_of_measure"] = "pieces"
        }
        try await ingredientCollection.addDocument(data: ingredientData)
        
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
        let stringUnitOfMeasure = data["unit_of_measure"] as? String
        let alertId = data["alert_id"] as? String
        
        var unitOfMeasure: UnitOfMeasure
        switch stringUnitOfMeasure {
        case "litres":
            unitOfMeasure = .litres
        case "kilograms":
            unitOfMeasure = .kilograms
        case "grams":
            unitOfMeasure = .grams
        default:
            unitOfMeasure = .pieces
        }
        
        return Ingredient(id: id, name: name ?? "", quantity: quantity ?? 0.0, expiringDate: expiringDate ?? Date(), photoUrl: photoUrl, unitOfMeasure: unitOfMeasure, alertId: alertId)
    }
    
    func getIngredients(handler: @escaping ([Ingredient]) -> Void) {
        var ingredients = [Ingredient]()
        database.collection("ingredients").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let ingredient = try document.data(as: Ingredient.self)
                        ingredients.append(ingredient)
                    } catch {
                        print("error in saving ingredient to the db: \(error)")
                    }
                }
                handler(ingredients)
            }
        }
        
    }
}
