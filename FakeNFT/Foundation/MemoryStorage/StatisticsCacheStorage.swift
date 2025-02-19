//
//  StatisticsCacheStorage.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 19.02.2025.
//

import Foundation

protocol StatisticsCacheStorageProtocol {
    func saveUsersToCache(_ users: [User])
    func loadUsersFromCache() -> [User]
}

final class StatisticsCacheStorage: StatisticsCacheStorageProtocol {
    
    private let cacheFileName = "usersCache.json"
    
    func saveUsersToCache(_ users: [User]) {
        let fileURL = getCacheFileURL()
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Ошибка сохранения данных в кэш: \(error.localizedDescription)")
        }
    }
    
    func loadUsersFromCache() -> [User] {
        let fileURL = getCacheFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            let cachedUsers = try JSONDecoder().decode([User].self, from: data)
            return cachedUsers
        } catch {
            print("Кэш пустой: \(error.localizedDescription)")
            return []
        }
    }
    
    private func getCacheFileURL() -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cachesDirectory.appendingPathComponent(cacheFileName)
    }
}
