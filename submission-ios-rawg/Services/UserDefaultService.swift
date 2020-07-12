//
//  UserDefaultService.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import Foundation

class UserDefaultServices {
    static let instance = UserDefaultServices()
    
    private let def = UserDefaults.standard
    
    fileprivate let orderPositionKey = "orderPositionKey"
    fileprivate let isAscendingKey = "isAscendingKey"
    
    var orderPosition: Int {
        get {
            return def.integer(forKey: orderPositionKey)
        }
        set {
            def.set(newValue, forKey: orderPositionKey)
        }
    }
    
    var isAscending: Int {
        get {
            return def.integer(forKey: isAscendingKey)
        }
        set {
            def.set(newValue, forKey: isAscendingKey)
        }
    }
}
