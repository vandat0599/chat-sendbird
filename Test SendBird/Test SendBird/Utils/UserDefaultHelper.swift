//
//  UserDefaultHelper.swift
//  sshhhh
//
//  Created by Duy Nguyen on 3/4/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

class UserDefaultHelper {
    enum Key: String {
        case access_token, sb_user
    }
    
    private static let defaults = UserDefaults.standard
    private static let jsonDecoder = JSONDecoder()
    private static let jsonEncoder = JSONEncoder()
    
    static func get(key: Key) -> Any? {
        return defaults.object(forKey: key.rawValue)
    }
    
    static func save(value: Any?, key: Key, async: Bool = false) {
        switch async {
        case true:
            let queue = DispatchQueue(label: "UserDefault")
            queue.async {
                defaults.set(value, forKey: key.rawValue)
            }
        case false:
            defaults.set(value, forKey: key.rawValue)
        }
    }
    
    static func remove(key: Key, async: Bool = false) {
        switch async {
        case true:
            let queue = DispatchQueue(label: "UserDefault")
            queue.async {
                defaults.removeObject(forKey: key.rawValue)
            }
        case false:
            defaults.removeObject(forKey: key.rawValue)
        }
    }
    
    // MARK: - Codable Object
    // If object has already exist, it will be overwrited
    static func saveCodableObject<T: Codable>(_ item: T, key: Key, async: Bool = false) {
        if let jsonData = try? jsonEncoder.encode(item) {
            self.save(value: jsonData, key: key, async: async)
            print("saveObject")
        } else {
            print("Cannot save UserProfile to UserDefault")
        }
    }
    
    static func getCodableObject<T: Codable>(key: Key) -> T? {
        if let jsonData = get(key: key) as? Data {
            return try? jsonDecoder.decode(T.self, from: jsonData)
        }
        return nil
    }
    
    // MARK: - Codable Array
    // If array has already exist, it will be overwrited
    static func saveCodableArray<T: Codable>(_ array: [T], key: Key, async: Bool = false) {
        if let jsonData = try? jsonEncoder.encode(array) {
            self.save(value: jsonData, key: key, async: async)
        } else {
            print("Cannot save UserProfile to UserDefault")
        }
    }
    
    static func getCodableArray<T: Codable>(key: Key) -> [T]? {
        if let jsonData = get(key: key) as? Data {
            return try? jsonDecoder.decode([T].self, from: jsonData)
        }
        return nil
    }
}
