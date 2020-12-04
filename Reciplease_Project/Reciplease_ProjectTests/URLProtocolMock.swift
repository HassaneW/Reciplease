//
//  URLSessionFake.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 10/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

@testable import Reciplease_Project
import Foundation
import XCTest
@testable import Alamofire

class URLProtocolMock: URLProtocol {
    
//    static var responseError: [URL: Result<Data, Error>] = [generateURL() : .success(FakeData.incorrectData)]
//    static var responseSuccess: [URL: Result<Data, Error>] = [generateURL() : .success(FakeData.recipeData)]
    static var mockError?
    static var mockSuccess?
    
    private static var mockURLs: [URL: Result<Data, Error>] = [
        generateURLFor(ingredient: "invalid") : .success(FakeData.incorrectData),
        generateURLFor(ingredient: "chicken") : .success(FakeData.recipeData)
    ]
  
    private static func generateURLFor(ingredient: String) -> URL {
        var url = ConfigNetworkingService.edelman.baseUrl
        url += "&app_id=\(ConfigNetworkingService.edelman.app_id)"
        url += "&app_key=\(ConfigNetworkingService.edelman.app_key)"
        url += "&from=0"
        url += "&q=\(ingredient)"
        url += "&to=10"
        return URL(string: url)!
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let mockError {

            client?.urlProtocol(self, didFailWithError: error)
        }
        
        
        let url = request.url!
        guard let response = URLProtocolMock.mockURLs[url] else {
            client?.urlProtocol(self, didFailWithError: AFError.invalidURL(url: url))
            return
        }
        
        switch response {
        case .failure(let error):
             client?.urlProtocol(self, didFailWithError: error)
        case .success(let data):
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() { }
}


class URLSessionDataTaskFake : URLSessionDataTask {
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data : Data?
    var urlResponse : URLResponse?
    var responseError: Error?
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {
    }
}
