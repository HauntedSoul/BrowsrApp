//
//  OrganizationExt.swift
//  BrowsrApp
//
//  Created by Vitor Dinis on 24/10/2022.
//

import Foundation
import BrowsrLib

extension Organization {
    
    func isFavourite() -> Bool {
        guard let favourites = UserDefaults.standard.array(forKey: DefaultsKey.favouritesKey) as? [Int64] else { return false }
        return favourites.contains(where: { $0 == id })
    }
    
    func addToFavourites() {
        UserDefaults.standard.addToIntArray(id, forKey: DefaultsKey.favouritesKey)
    }
    
    func removeFromFavourites() {
        UserDefaults.standard.removeAllFromIntArray(id, forKey: DefaultsKey.favouritesKey)
    }
}

struct DefaultsKey {
    static let favouritesKey = "favourite_organizations"
}

extension UserDefaults {
    
    /// Adds an Int value to an array
    func addToIntArray(_ value: Int64, forKey: String) {
        guard var array = self.array(forKey: forKey) as? [Int64] else { return }
        
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
