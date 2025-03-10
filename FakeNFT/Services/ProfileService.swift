import Foundation
import Combine

protocol ProfileService {
    func fetchProfileCombine(
        profile: Profile?,
        skipCache: Bool
    ) -> AnyPublisher<Profile, Error>
}

enum ProfileServiceError: Error {
    case invalidResponse
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let cacheService: CacheService
    private let networkMonitor: NetworkMonitor
    private let cacheLifetime: TimeInterval = 10 * 60
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
            .sink { isConnected in
                print("Сеть доступна: \(isConnected)")
            }
            .store(in: &cancellables)
    }

    // MARK: - Combine
    func fetchProfileCombine(
        profile: Profile?,
        skipCache: Bool
    ) -> AnyPublisher<Profile, Error> {
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

    private func cachePublisher() -> AnyPublisher<Profile, Error> {
        let key = cacheKey()

        return Future<Profile, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CacheError.emptyOrStale))
                return
            }

            self.cacheService.load(type: Profile.self, forKey: key) { result in
                switch result {
                case .success(let (cachedProfile, lastUpdated)):
                    let cacheIsFresh = Date().timeIntervalSince(lastUpdated) < self.cacheLifetime
                    if cacheIsFresh {
                        promise(.success(cachedProfile))
                    } else {
                        promise(.failure(CacheError.emptyOrStale))
                    }
                case .failure:
                    promise(.failure(CacheError.emptyOrStale))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func networkPublisher(profile: Profile?) -> AnyPublisher<Profile, Error> {
        return Future<Profile, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "ProfileService", code: -1, userInfo: nil)))
                return
            }

            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                print("DEBUG: ERROR ProfileService - no internet connection")
                return
            }

            let key = self.cacheKey()
            let request = CollectionProfileRequest(profile: profile)

            self.networkClient.send(
                request: request,
                type: ProfileDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    guard let convertedModel = response.toUIModel() else {
                        promise(.failure(ProfileServiceError.invalidResponse))
                        print("DEBUG: ERROR ProfileService - invalid response")
                        return
                    }

                    self.cacheService.save(data: convertedModel, forKey: key)
                    promise(.success(convertedModel))
                case .failure(let error):
                    promise(.failure(error))
                    print("DEBUG: ERROR ProfileService - \(error)")
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
