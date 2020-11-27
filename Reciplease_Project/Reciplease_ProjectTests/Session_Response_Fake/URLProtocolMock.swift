//
//  URLSessionFake.swift
//  Reciplease_ProjectTests
//
//  Created by Wandianga hassane on 10/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation

class URLProtocolMock: URLProtocol {
    
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
