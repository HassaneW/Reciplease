//
//  Reciplease.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/28/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Recipe

struct Recipe {
    let title: String
    let imageUrl: String
    let url: String
    let portions: Float
    let ingredients: [String]
    let totalTime: Float
}

 // MARK: - extension Recipe

extension Recipe: Decodable {
    enum CodingKeys: String, CodingKey {
        case recipe
        case title = "label"
        case imageUrl = "image"
        case url
        case portions = "yield"
        case ingredients  = "ingredientLines"
        case totalTime
    }
    
     // MARK: - init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recipe = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .recipe)
        
         // MARK: - decode Recipe
        
        title = try recipe.decode(String.self, forKey: .title)
        imageUrl = try recipe.decode(String.self, forKey: .imageUrl)
        url = try recipe.decode(String.self, forKey: .url)
        portions = try recipe.decode(Float.self, forKey: .portions)
        ingredients = try recipe.decode([String].self, forKey: .ingredients)
        totalTime = try recipe.decode(Float.self, forKey: .totalTime)
    }
}

// MARK: - CustomStringConvertible

extension Recipe : CustomStringConvertible {
    var description: String {
        return "Title : \(title), Image recette \(imageUrl), descriptif recette \(url), Portions : \(portions), tableau d'ingrédients : \(ingredients), temps de preparation \(totalTime)"
    }
}

// MARK: - Convert Recipe Model

extension Recipe {
    
    init(from recipeEntity: RecipeEntity) {
        title = recipeEntity.title ?? ""
        imageUrl = recipeEntity.imageUrl ?? ""
        url = recipeEntity.url ?? ""
        portions = recipeEntity.portions
        totalTime = recipeEntity.totalTime
        
        if let ingredientsData = recipeEntity.ingredients,
            let unwrappedIngredients = try? JSONDecoder().decode([String].self, from: ingredientsData) {
            ingredients = unwrappedIngredients
        } else {
            ingredients = []
        }
    }
}


// MARK: - Reciplease

struct Reciplease: Decodable {
    
    let recipes: [Recipe]
    enum CodingKeys: String, CodingKey {
        case recipes = "hits"
    }
}
