//
//  StatisticsCacheStorage.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 19.02.2025.
//

import Foundation

protocol StatisticsCacheStorageProtocol {
    func saveUsersToCache(_ users: [User])
    func loadUsersFromCache() -> [User]?
    func clearStatisticsCache()
}

final class StatisticsCacheStorage: StatisticsCacheStorageProtocol {
    
    private let cacheFileName = "usersCache.json"
    
    func saveUsersToCache(_ users: [User]) {
        guard let fileURL = getCacheFileURL(caller: "[saveUsersToCache]") else { return }
        
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Ошибка сохранения данных в кэш: \(error.localizedDescription)")
        }
    }
    
    func loadUsersFromCache() -> [User]? {
        guard let fileURL = getCacheFileURL(caller: "[loadUsersFromCache]") else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let cachedUsers = try JSONDecoder().decode([User].self, from: data)
            return cachedUsers
        } catch {
            print("Кэш пустой: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearStatisticsCache() {
        guard let fileURL = getCacheFileURL(caller: "[clearStatisticsCache]") else { return }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Ошибка при очистке кэша: \(error.localizedDescription)")
        }
    }
    
    private func getCacheFileURL(caller: String) -> URL? {
        guard let cachesDirectory = FileManager.default.urls(
            for: .cachesDirectory, 
            in: .userDomainMask
        ).first else {
            print("[StatisticsCacheStorage] - \(caller): Не удалось получить URL для кэша")
            return nil
        }
        return cachesDirectory.appendingPathComponent(cacheFileName)
    }
}
