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
    
    var networkService: NetworkService!
    var session: Session!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        session = Session(configuration: configuration)
        networkService = NetworkService(session: session)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRecipesSuccess() {
        //TODO
    }

    func testFetchRecipesFailure() {
        //TODO
    }
}
