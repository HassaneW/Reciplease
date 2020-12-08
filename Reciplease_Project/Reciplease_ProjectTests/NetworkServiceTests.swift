//
//  NetworkServiceTests.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 27/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

@testable import Reciplease_Project
@testable import Alamofire
import XCTest

class NetworkServiceTests: XCTestCase {
    
    private var networkService: NetworkServiceRecipe!
    private var session: Session!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        session = Session(configuration: configuration)
        networkService = NetworkServiceRecipe(session: session)
    }
    
    override func tearDownWithError() throws {
        URLProtocolMock.successData = nil
        URLProtocolMock.error = nil
    }
    
    func testFetchRecipesSuccess() {
       
        URLProtocolMock.successData = FakeData.recipeData
        
        let expectation = XCTestExpectation(description: "load request triggers success")
        
        networkService.getRecipes(ingredients: "chicken") { (result) in
     
            switch result {
            case .success(let result):
                XCTAssertEqual(result.recipes, FakeData.recipes)
                
                let recipe = try! XCTUnwrap(result.recipes.first, "recipe not found")
                XCTAssertEqual(recipe.title, "Chicken Vesuvio")
                XCTAssertEqual(recipe.imageUrl, "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")
                XCTAssertEqual(recipe.url, "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html")
                XCTAssertEqual(recipe.portions, 4.0)
                XCTAssertEqual(recipe.totalTime, 60.0)
                XCTAssertEqual(recipe.ingredients.first, "1/2 cup olive oil")
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for : [expectation], timeout: 1)
    }
    
    func testFetchRecipesFailure() {

        URLProtocolMock.error = AFError.explicitlyCancelled
        
        let expectation = XCTestExpectation(description: "load request triggers error")
        
        networkService.getRecipes(ingredients: "error recipe") { result in
            
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error.errorDescription?.contains("URLSessionTask failed with error"))
            }
            expectation.fulfill()
        }
        wait(for : [expectation], timeout: 1)
    }
}
