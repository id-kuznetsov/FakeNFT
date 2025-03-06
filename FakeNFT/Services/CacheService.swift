//
//  CacheService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 04.03.2025.
//

import Foundation

protocol CacheService {
    func save<T: Codable>(data: T, forKey key: String)
    func load<T: Codable>(
        type: T.Type,
        forKey key: String,
        completion: @escaping (Result<(T, Date), Error>) -> Void
    )
    func clearCache(forKey key: String)
}

class CacheServiceImpl: CacheService {
    private let memoryCache = NSCache<NSString, CacheWrapper>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL?

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
            print("⚠️  CacheService -Не удалось получить путь к папки кэша")
            self.cacheDirectory = nil
        }
    }

    func save<T: Codable>(data: T, forKey key: String) {
        guard let cacheDirectory = cacheDirectory else { return }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")
        let metadata = CacheMetadata(data: data, timestamp: Date())

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

    func load<T: Codable>(
        type: T.Type,
        forKey key: String,
        completion: @escaping (Result<(T, Date), Error>) -> Void
    ) {
        if let cachedObject = memoryCache.object(forKey: key as NSString)?.value as? CacheMetadata<T> {
            completion(.success((cachedObject.data, cachedObject.timestamp)))
            return
        }

        guard let cacheDirectory = cacheDirectory else {
            completion(
                .failure(
                    NSError(
                        domain: "CacheService", code: 404, userInfo: [
                            NSLocalizedDescriptionKey: "Каталог кэша недоступен"
                        ]
                    )
                )
            )
            return
        }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: cacheFile)
                let metadata = try JSONDecoder().decode(CacheMetadata<T>.self, from: data)
                self.memoryCache.setObject(CacheWrapper(value: metadata), forKey: key as NSString)

                DispatchQueue.main.async {
                    completion(.success((metadata.data, metadata.timestamp)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    func clearCache(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)

        guard let cacheDirectory = cacheDirectory else { return }

        let cacheFile = cacheDirectory.appendingPathComponent("\(key).json")
        try? fileManager.removeItem(at: cacheFile)
    }
}

/// **Структура для хранения данных + времени**
struct CacheMetadata<T: Codable>: Codable {
    let data: T
    let timestamp: Date
}

/// **Обёртка для хранения в NSCache**
class CacheWrapper: NSObject {
    let value: Any
    init(value: Any) {
        self.value = value
    }
}
