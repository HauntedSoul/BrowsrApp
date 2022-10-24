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

