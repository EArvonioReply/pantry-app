//
//  PantryViewControllerViewModel.swift
//  pantry-app
//
//  Created by Marco Agizza on 26/09/23.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import CodableFirebase
import MVVMKit

class PantryViewControllerViewModel {
    
    private let database = Firestore.firestore()
    
    var ingredients: [Ingredient] = []
    
    var numberOfIngredients: Int {
        return ingredients.count
    }
    
    func loadData(handler: @escaping () -> Void) {
        observeIngredients(handler: handler)
    }
    
    func getIngredient(at position: Int) -> Ingredient {
        return ingredients[position]
    }
    
    func add(new ingredient: Ingredient) {
        ingredients.append(ingredient)
        Task {
            do {
                try await IngredientManager.shared.saveIngredient(ingredient)
            } catch {
                print("error in saving ingredient to the db: \(error)")
            }
        }
    }
    
    func observeIngredients(handler: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        database.collection("ingredients").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    dispatchGroup.enter()
                    Task {
                        defer {
                            dispatchGroup.leave()
                        }
                        do {
                            let ingredient = try await IngredientManager.shared.getIngredient(ingredientID: document.documentID)
                            print(ingredient)
                            self.ingredients.append(ingredient)
                            
                        } catch {
                            print("error in saving ingredient to the db: \(error)")
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    handler()
                }
                
            }
        }
    }
    
}
