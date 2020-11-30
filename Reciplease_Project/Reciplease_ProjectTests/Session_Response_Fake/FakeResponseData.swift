//
//  FakeResponseData.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 10/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

@testable import Reciplease_Project
import Foundation

class FakeResponseData {
    
//    static var recipes: [Recipe] {
//        return reciplease.recipes
//    }
    
//    static var reciplease: Reciplease {
        //TODO: get the json and decode it
//        return Reciplease()
//    }
    
//    static let responseOK = HTTPURLResponse(url: URL(string: "https://apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//    static let responseKO = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
//    class ServiceError: Error {}
//    static let error = ServiceError()
    
    static var recipeData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "recipe", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let incorrectData = "erreur".data(using: .utf8)!
}
