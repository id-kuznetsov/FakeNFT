//
//  SortStateStorage.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 17.02.2025.
//

import Foundation

final class SortStateStorage {
    
    static let shared = SortStateStorage()

    var sortOptionInCart: String? {
        get {
            storage.string(forKey: Keys.sortOptionInCart.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.sortOptionInCart.rawValue)
        }
    }
    
    private enum Keys: String {
        case sortOptionInCart
    }
    private let storage = UserDefaults.standard
    
    private init() {}
}
