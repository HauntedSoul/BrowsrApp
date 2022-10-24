//
//  UserDefaultsExt.swift
//  BrowsrApp
//
//  Created by Vitor Dinis on 24/10/2022.
//

import Foundation

extension UserDefaults {
    
    /// Adds an Int value to an array
    func addToIntArray(_ value: Int64, forKey: String) {
        var array = self.array(forKey: forKey) as? [Int64] ?? []
        
        array.append(value)
        UserDefaults.standard.set(array, forKey: forKey)
    }
    
    /// Removes all Int values matching from an array
    func removeAllFromIntArray(_ value: Int64, forKey: String) {
        guard var array = self.array(forKey: forKey) as? [Int64] else { return }
        
        array.removeAll(where: { $0 == value })
        UserDefaults.standard.set(array, forKey: forKey)
    }
}

struct DefaultsKey {
    static let favouritesKey = "favourite_organizations"
}
