//
//  CatalogSortOptionStorage.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 03.03.2025.
//

import Foundation

protocol CatalogSortOptionStorage {
    func saveSortOption(_ option: CollectionSortOptions)
    func loadSortOption() -> CollectionSortOptions
}

@propertyWrapper
struct UserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults

    init(
        key: String,
        defaultValue: Value,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: Value {
        get {
            guard let value = userDefaults.object(forKey: key) as? Value else {
                return defaultValue
            }
            return value
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}

final class CatalogSortOptionStorageImpl: CatalogSortOptionStorage {
    @UserDefault(
        key: "CollectionSortOption",
        defaultValue: CollectionSortOptions.none.rawValue,
        userDefaults: UserDefaults.standard
    )
    private var storedSortOption: String

    func saveSortOption(_ option: CollectionSortOptions) {
        storedSortOption = option.rawValue
    }

    func loadSortOption() -> CollectionSortOptions {
        guard let sortOption = CollectionSortOptions(rawValue: storedSortOption) else {
            return .none
        }
        return sortOption
    }
}
