import Foundation
import Combine

typealias ProfileCompletion = (Result<ProfileDTO, ProfileServiceError>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion)
    func updateFavouritesNft(favourites: [String], _ completion: @escaping ProfileCompletion)
    func fetchProfileCombine(
        profile: Profile?,
        skipCache: Bool
    ) -> AnyPublisher<Profile, Error>
}

enum ProfileServiceError: Error {
    case profileFetchingFail
    case profileUpdatingFail
    case invalidResponse
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private var fetchProfileTask: NetworkTask?
    private var updateProfileTask: NetworkTask?
    private var updateFavouritesTask: NetworkTask?

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

    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        fetchProfileTask?.cancel()
        let request = ProfileRequest()

        fetchProfileTask = networkClient.send(request: request, type: ProfileDTO.self) { [weak self] result in
            self?.fetchProfileTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure:
                completion(.failure(.profileFetchingFail))
            }
        }
    }

    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion) {
        updateProfileTask?.cancel()
        let request = ProfileEditingRequest(dto: dto)

        updateProfileTask = networkClient.send(request: request, type: ProfileDTO.self) { [weak self] result in
            self?.updateProfileTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure:
                completion(.failure(.profileUpdatingFail))
            }
        }
    }

    func updateFavouritesNft(favourites: [String], _ completion: @escaping ProfileCompletion) {
        updateFavouritesTask?.cancel()
        let dto = ProfileFavouritesDto(likes: favourites)
        let request = FavouritesPutRequest(dto: dto)

        updateFavouritesTask = networkClient.send(request: request, type: ProfileDTO.self) { [weak self] result in
            self?.updateFavouritesTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure:
                completion(.failure(.profileUpdatingFail))
            }
        }
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
                case .success(let cacheResult):
                    promise(.success(cacheResult.data))
                case .failure(let error):
                    promise(.failure(error))
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
