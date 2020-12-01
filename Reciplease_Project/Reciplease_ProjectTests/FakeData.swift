//
//  FakeData.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 10/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

@testable import Reciplease_Project
import Foundation

class FakeData {
    
    private static var recipeData: Data {
        let bundle = Bundle(for: self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")
        return try! Data(contentsOf: url!)
    }
      
    private static var results: Reciplease {
        return try! JSONDecoder().decode(Reciplease.self, from: recipeData)
    }
    
    static var recipes: [Recipe] {
        return results.recipes
    }
    
    static let incorrectData = "incorrect data".data(using: .utf8)!
}
