//
//  String.swift
//  Reciplease_Project
//
//  Created by Wandianga on 9/29/20.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import Foundation


extension String {
    var isEmptyOrWhitespace: Bool {
          return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      }
}

// Out of range
extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
