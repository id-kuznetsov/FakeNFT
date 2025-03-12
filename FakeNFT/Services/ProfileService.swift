import Foundation
import Combine

protocol ProfileService {
    func fetchProfileCombine(
        profile: CatalogProfile?,
        skipCache: Bool
    ) -> AnyPublisher<CatalogProfile, Error>
}

enum ProfileServiceError: Error {
    case invalidResponse
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let cacheService: CacheService
    private let networkMonitor: NetworkMonitor
    private var cancellables = Set<AnyCancellable>()

    init(
        networkClient: NetworkClient,
        cacheService: CacheService,
        networkMonitor: NetworkMonitor
    ) {
        self.networkClient = networkClient
        self.cacheService = cacheService
        self.networkMonitor = networkMonitor

        self.networkMonitor.connectivityPublisher
            .sink { _ in }
            .store(in: &cancellables)
    }

    // MARK: - Combine
    func fetchProfileCombine(
        profile: CatalogProfile?,
        skipCache: Bool
    ) -> AnyPublisher<CatalogProfile, Error> {
        let networkPublisher = networkPublisher(profile: profile)

        if skipCache {
            return networkPublisher
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return cachePublisher()
                .flatMap { cached in
                    Just(cached)
                        .setFailureType(to: Error.self)
                        .append(networkPublisher)
                        .eraseToAnyPublisher()
                }

                .catch { _ in networkPublisher }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    private func cacheKey() -> String { "profile" }

    private func cachePublisher() -> AnyPublisher<CatalogProfile, Error> {
        let key = cacheKey()

        return Future<CatalogProfile, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CacheError.emptyOrStale))
                return
            }

            self.cacheService.load(type: CatalogProfile.self, forKey: key) { result in
                switch result {
                case .success(let cacheResult):
                    promise(.success(cacheResult.data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func networkPublisher(profile: CatalogProfile?) -> AnyPublisher<CatalogProfile, Error> {
        return Future<CatalogProfile, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "ProfileService", code: -1, userInfo: nil)))
                return
            }

            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                return
            }

            let key = self.cacheKey()
            let request = CollectionProfileRequest(profile: profile)

            self.networkClient.send(
                request: request,
                type: CatalogProfileDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    guard let convertedModel = response.toDomainModel() else {
                        promise(.failure(ProfileServiceError.invalidResponse))
                        return
                    }
                    /// API doesn't provide ttl
                    let ttl: TimeInterval? = nil
                    self.cacheService.save(data: convertedModel, ttl: ttl, forKey: key)
                    promise(.success(convertedModel))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
