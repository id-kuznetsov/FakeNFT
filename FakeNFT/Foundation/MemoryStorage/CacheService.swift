//
//  CacheService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 04.03.2025.
//

import UIKit

protocol CacheService {
    func save<T: Codable>(data: T, ttl: TimeInterval?, forKey key: String)
    func load<T: Codable>(
        type: T.Type,
        forKey key: String,
        completion: @escaping (Result<CacheResult<T>, Error>) -> Void
    )
    func clearCache(forKey key: String)
}

/// Обёртка для хранения в NSCache
class CacheWrapper: NSObject {
    let value: Any
    init(value: Any) {
        self.value = value
    }
}

/// Структура для хранения данных + времени
struct CacheMetadata<T: Codable>: Codable {
    let data: T
    let timestamp: Date
    let ttl: TimeInterval?
}

/// Структура для декодирования метаданных при очистке кэша
struct CacheTimestamp: Codable {
    let timestamp: Date
    let ttl: TimeInterval?
}

struct CacheResult<T: Codable> {
    let data: T
    let timestamp: Date
    let ttl: TimeInterval?
}

enum CacheError: Error {
    case emptyOrStale
    case cacheCatalogNotFound
}

final class CacheServiceImpl: CacheService {
    private let memoryCache = NSCache<NSString, CacheWrapper>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL?
    private var cachingEnabled: Bool = true
    /// 10 минут
    private let defaultTTL: TimeInterval = 10 * 60
    /// Минимально допустимый объём места на диске 50 МБ
    private let minDiskSpaceThreshold: Int64 = 50 * 1024 * 1024

    private var simulateLowDiskSpace = false

    // MARK: - Init
    init() {
        if let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let cacheURL = url.appendingPathComponent("AppCache")
            do {
                try fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
                self.cacheDirectory = cacheURL
            } catch {
                print("⚠️ CacheService - Ошибка создания папки кэша: \(error.localizedDescription)")
                self.cacheDirectory = nil
            }
        } else {
            print("⚠️ CacheService - Не удалось получить путь к папке кэша")
            self.cacheDirectory = nil
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )

        Timer.scheduledTimer(withTimeInterval: 10 * 60, repeats: true) { [weak self] _ in
            self?.clearExpiredCache()
        }
    }

    // MARK: - Save
    func save<T: Codable>(data: T, ttl: TimeInterval?, forKey key: String) {
        guard cachingEnabled else {
            print("⚠️ CacheService - Кэширование отключено. Пропуск сохранения.")
            return
        }

        guard let cacheDirectory = cacheDirectory else { return }

        guard hasEnoughDiskSpace() else { return }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")
        let metadata = CacheMetadata(data: data, timestamp: Date(), ttl: ttl)

        memoryCache.setObject(CacheWrapper(value: metadata), forKey: key as NSString)

        DispatchQueue.global(qos: .background).async {
            if let encoded = try? JSONEncoder().encode(metadata) {
                do {
                    try encoded.write(to: cacheFile)
                } catch {
                    print("⚠️ CacheService - Ошибка записи данных в кэш: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Load
    func load<T: Codable>(
        type: T.Type,
        forKey key: String,
        completion: @escaping (Result<CacheResult<T>, Error>) -> Void
    ) {
        /// Попытка загрузки из памяти
        if let cachedObject = memoryCache.object(forKey: key as NSString)?.value as? CacheMetadata<T> {
            let ttl = cachedObject.ttl ?? defaultTTL
            if Date().timeIntervalSince(cachedObject.timestamp) > ttl {
                memoryCache.removeObject(forKey: key as NSString)
            } else {
                completion(
                    .success(
                        CacheResult(
                            data: cachedObject.data,
                            timestamp: cachedObject.timestamp,
                            ttl: cachedObject.ttl
                        )
                    )
                )
                return
            }
        }

        /// Если записи в памяти нет или она устарела, проверяем файл на диске
        guard let cacheDirectory = cacheDirectory else {
            completion(.failure(CacheError.cacheCatalogNotFound))
            return
        }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: cacheFile)
                let metadata = try JSONDecoder().decode(CacheMetadata<T>.self, from: data)
                let ttl = metadata.ttl ?? self.defaultTTL

                /// Если время жизни кэша истекло — удаляем файл и возвращаем ошибку
                if Date().timeIntervalSince(metadata.timestamp) > ttl {
                    try self.fileManager.removeItem(at: cacheFile)
                    DispatchQueue.main.async {
                        completion(.failure(CacheError.emptyOrStale))
                    }
                } else {
                    self.memoryCache.setObject(CacheWrapper(value: metadata), forKey: key as NSString)
                    DispatchQueue.main.async {
                        completion(.success(CacheResult(data: metadata.data,
                                    timestamp: metadata.timestamp,
                                    ttl: metadata.ttl)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(CacheError.emptyOrStale))
                }
            }
        }
    }

    func clearCache(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        guard let cacheDirectory = cacheDirectory else { return }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")
        try? fileManager.removeItem(at: cacheFile)
    }

    // MARK: - Helpers
    /// Метод для удаления устаревших кэш-файлов из каталога
    private func clearExpiredCache() {
        guard let cacheDirectory = cacheDirectory else { return }

        do {
            let files = try fileManager.contentsOfDirectory(
                at: cacheDirectory,
                includingPropertiesForKeys: nil,
                options: []
            )
            for file in files {
                if let data = try? Data(contentsOf: file),
                   let timestampContainer = try? JSONDecoder().decode(CacheTimestamp.self, from: data) {
                    let ttl = timestampContainer.ttl ?? defaultTTL
                    if Date().timeIntervalSince(timestampContainer.timestamp) > ttl {
                        try fileManager.removeItem(at: file)
                        print("⚠️ CacheService - Удалён устаревший кэш: \(file.lastPathComponent)")
                    }
                }
            }
        } catch {
            print("⚠️ CacheService - Ошибка при очистке устаревшего кэша: \(error.localizedDescription)")
        }
    }

    /// Проверка свободного места на диске
    private func hasEnoughDiskSpace() -> Bool {
        if simulateLowDiskSpace {
            print("⚠️ CacheService - Включён режим симуляции недостаточного места на диске.")
            return false
        }

        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let freeSize = attributes[.systemFreeSize] as? Int64 {
                return freeSize > minDiskSpaceThreshold
            }
        } catch {
            print("⚠️ CacheService - Не удалось получить информацию о свободном месте: \(error.localizedDescription)")
        }
        return false
    }

    // MARK: - Actions
    @objc private func handleMemoryWarning() {
        cachingEnabled = false
        memoryCache.removeAllObjects()
        clearExpiredCache()
        print("⚠️ CacheService - Получено уведомление о нехватке памяти. Кэширование отключено.")
    }
}
