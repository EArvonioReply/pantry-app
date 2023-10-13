//
//  Recipe.swift
//  pantry-app
//
//  Created by Marco Agizza on 10/10/23.
//

import UIKit

struct Recipe: Decodable {
    let title: String
    let photoUrl: String
    let missedIngredientCount: Int
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case title
        case photoUrl = "image"
        case missedIngredientCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        photoUrl = try container.decode(String.self, forKey: .photoUrl)
        missedIngredientCount = try container.decode(Int.self, forKey: .missedIngredientCount)
    }
    
}
