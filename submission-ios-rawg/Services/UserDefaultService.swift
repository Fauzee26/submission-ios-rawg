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
    
    fileprivate let profileNameKey = "nameKey"
    fileprivate let profileEmailKey = "emailKey"
    fileprivate let profilePhoneNumberKey = "phoneNumberKey"
    fileprivate let profileImageKey = "imageKey"
    fileprivate let hasLaunchedKey = "hasLaunchedKey"
    
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
    
    //MARK: - PROFILE SECTIONS
    var profileName: String {
        get {
            return def.string(forKey: profileNameKey) ?? ""
        }
        set {
            def.set(newValue, forKey: profileNameKey)
        }
    }
    
    var profileEmail: String {
        get {
            return def.string(forKey: profileEmailKey) ?? ""
        }
        set {
            def.set(newValue, forKey: profileEmailKey)
        }
    }
    
    var profilePhoneNumber: String {
        get {
            return def.string(forKey: profilePhoneNumberKey) ?? ""
        }
        set {
            def.set(newValue, forKey: profilePhoneNumberKey)
        }
    }
    
    var profileImage: Data? {
        get {
            return def.data(forKey: profileImageKey)
        }
        set {
            def.set(newValue, forKey: profileImageKey)
        }
    }
    
    var hasLaunched: Bool {
        get {
            return def.bool(forKey: hasLaunchedKey)
        }
        set {
            def.set(newValue, forKey: hasLaunchedKey)
        }
    }
}
