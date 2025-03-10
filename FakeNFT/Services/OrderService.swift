import Foundation
import Combine

protocol OrderService {
    func fetchOrderCombine(order: Order?, skipCache: Bool) -> AnyPublisher<Order, Error>
}

final class OrderServiceImpl: OrderService {
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
    func fetchOrderCombine(
        order: Order?,
        skipCache: Bool
    ) -> AnyPublisher<Order, Error> {
        let networkPublisher = networkPublisher(order: order)

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

    private func cacheKey() -> String { "order" }

    private func cachePublisher() -> AnyPublisher<Order, Error> {
        let key = cacheKey()

        return Future<Order, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CacheError.emptyOrStale))
                return
            }

            self.cacheService.load(type: Order.self, forKey: key) { result in
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

    private func networkPublisher(order: Order?) -> AnyPublisher<Order, Error> {
        return Future<Order, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "OrderService", code: -1, userInfo: nil)))
                return
            }

            if !self.networkMonitor.isConnected {
                promise(.failure(NetworkMonitorError.noInternetConnection))
                return
            }

            let key = self.cacheKey()
            let request = CollectionOrderRequest(order: order)

            self.networkClient.send(
                request: request,
                type: OrderDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    let convertedModel = response.toDomainModel()
                    self.cacheService.save(data: convertedModel, forKey: key)
                    promise(.success(convertedModel))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
