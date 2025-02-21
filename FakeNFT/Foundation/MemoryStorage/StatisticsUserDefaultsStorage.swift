//
//  StatisticsUserDefaultsStorage.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 19.02.2025.
//

import Foundation

protocol StatisticsUserDefaultsStorageProtocol {
    var currentPage: Int { get set }
    var previousPageSize: Int { get set }
    var selectedUsersSortOption: SortOption { get set }
    func clearStatisticsUserDefaults()
}

final class StatisticsUserDefaultsStorage: StatisticsUserDefaultsStorageProtocol {
    
    private let storage = UserDefaults.standard
    
    var currentPage: Int {
        get {
            return storage.integer(forKey: Keys.currentPage.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.currentPage.rawValue)
        }
    }
    
    var previousPageSize: Int {
        get {
            return storage.integer(forKey: Keys.previousPageSize.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.previousPageSize.rawValue)
        }
    }
    
    var selectedUsersSortOption: SortOption {
        get {
            if let title = storage.string(forKey: Keys.sortOptionInStatistics.rawValue) {
                return SortOption.allCases.first { $0.title == title } ?? .name
            }
            return .name
        }
        set {
            storage.set(newValue.title, forKey: Keys.sortOptionInStatistics.rawValue)
        }
    }
    
    func clearStatisticsUserDefaults() {
        storage.removeObject(forKey: Keys.currentPage.rawValue)
        storage.removeObject(forKey: Keys.sortOptionInStatistics.rawValue)
    }
    
    private enum Keys: String {
        case sortOptionInStatistics
        case currentPage
        case previousPageSize
    }
}
