//
//  Service.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/28/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation
import Alamofire

class NetworkServiceRecipe {
    
    // MARK: - Variables
    static let shared = NetworkServiceRecipe()
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    let baseURL = ConfigNetworkingService.edelman.baseUrl
    
    // MARK: - Session
    func getRecipes(ingredients: String, offset: Int = 0, callback: @escaping (Result<Reciplease, AFError>) -> Void) {
        let parameters: [String: Any] = [
            "app_id": ConfigNetworkingService.edelman.app_id,
            "app_key": ConfigNetworkingService.edelman.app_key,
            "q": "\(ingredients)",
            "from": offset,
            "to": offset + 10
        ]
        session.request(baseURL, parameters: parameters)
            .validate()
            .responseDecodable(of: Reciplease.self) { (response) in
                callback(response.result)
        }
    }
}

