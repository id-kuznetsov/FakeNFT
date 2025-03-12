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
    private let cacheTime: TimeInterval = 600 // 10 мин. - срок хранения кэша
    
    func saveUsersToCache(_ users: [User]) {
        let cachedData = CachedUsers(users: users, timestamp: Date().timeIntervalSince1970)
        guard let fileURL = getCacheFileURL(caller: "[saveUsersToCache]") else { return }
        
        do {
            let data = try JSONEncoder().encode(cachedData)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Ошибка сохранения данных в кэш: \(error.localizedDescription)")
        }
    }
    
    func loadUsersFromCache() -> [User]? {
        guard let fileURL = getCacheFileURL(caller: "[loadUsersFromCache]") else { return nil }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let cachedData = try JSONDecoder().decode(CachedUsers.self, from: data)
            
            let currentTime = Date().timeIntervalSince1970
            let cacheAge = currentTime - cachedData.timestamp

            if cacheAge > cacheTime {
                clearStatisticsCache()
                return nil
            }

            return cachedData.users
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
