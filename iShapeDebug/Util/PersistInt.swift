//
//  PersistInt.swift
//  iShapeDebug
//
//  Created by Nail Sharipov on 18.03.2023.
//

import Foundation

final class PersistInt {
    
    private let key: String
    private let nilValue: Int
    
    var value: Int {
        get {
            guard UserDefaults.standard.value(forKey: key) != nil else {
                return nilValue
            }
            return UserDefaults.standard.integer(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    init(key: String, nilValue: Int = 0) {
        self.key = key
        self.nilValue = nilValue
    }

    func increase(amount: Int) -> Int {
        let a = value + amount
        value = a
        return a
    }
    
}
