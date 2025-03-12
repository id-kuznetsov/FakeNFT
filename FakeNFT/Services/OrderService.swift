import Foundation
import Combine

protocol OrderService {
    func fetchOrderCombine(order: CatalogOrder?, skipCache: Bool) -> AnyPublisher<CatalogOrder, Error>
}

final class OrderServiceImpl: OrderService {
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
    func fetchOrderCombine(
        order: CatalogOrder?,
        skipCache: Bool
    ) -> AnyPublisher<CatalogOrder, Error> {
        let networkPublisher = networkPublisher(order: order)

        if skipCache {
            return networkPublisher
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return cachePublisher()
            /// Если кэш получен, отдаём его сразу, а затем выполняем обновление из сети
                .flatMap { cached in
                    Just(cached)
                        .setFailureType(to: Error.self)
                        .append(networkPublisher)
                        .eraseToAnyPublisher()
                }
            /// Если кэш недоступен или устарел, переходим к запросу в сеть
                .catch { _ in networkPublisher }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }

    private func cacheKey() -> String {
        return "order"
    }

    private func cachePublisher() -> AnyPublisher<CatalogOrder, Error> {
        let key = cacheKey()

        return Future<CatalogOrder, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(CacheError.emptyOrStale))
                return
            }

            self.cacheService.load(type: CatalogOrder.self, forKey: key) { result in
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

    private func networkPublisher(order: CatalogOrder?) -> AnyPublisher<CatalogOrder, Error> {
        return Future<CatalogOrder, Error> { [weak self] promise in
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
                type: CatalogOrderDTO.self
            ) { result in
                switch result {
                case .success(let response):
                    let convertedModel = response.toDomainModel()
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
