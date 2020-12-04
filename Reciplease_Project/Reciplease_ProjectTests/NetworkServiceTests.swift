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
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRecipesSuccess() {
        URLProtocolMock.mockError = .success(FakeData.incorrectData)
        
        let expectation = XCTestExpectation(description: "load request")
        networkService.getRecipes(ingredients: "chicken") { (result)  in
            
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes.recipes, FakeData.recipes)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for : [expectation], timeout: 1)
    }
    
    func testFetchRecipesFailure() {
        
        let expectation = XCTestExpectation(description: "load request")
        networkService.getRecipes(ingredients: "invalid") { (result)  in
            
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertTrue(((error.errorDescription?.contains("test me")) != nil))
                //XCTAssertEqual(error.errorDescription, requestError.errorDescription)
            }
            expectation.fulfill()
        }
        wait(for : [expectation], timeout: 1)
    }
}
