//
//  UserDefaultsManager.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 12/12/2021.
//

import Foundation

extension UserDefaults {
    var availableFruits: [AvailableFruit] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "availableFruit") else { return [] }
            return (try? PropertyListDecoder().decode([AvailableFruit].self, from: data)) ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "availableFruit")
        }
    }
}

