//
//  URLSessionFake.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 10/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import XCTest

class URLProtocolMock: URLProtocol {
    
    static var error: Error?
    static var successData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = URLProtocolMock.error {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        guard let successData = URLProtocolMock.successData else {
            XCTFail("Invalid success data received")
            return
        }
        
        client?.urlProtocol(self, didLoad: successData)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
