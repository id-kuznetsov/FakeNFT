import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void
typealias OrderPutCompletion = (Result<Order, Error>) -> Void
typealias CurrenciesCompletion = (Result<CurrencyValues, Error>) -> Void
typealias SetCurrencyCompletion = (Result<CurrencyPaymentResponse, Error>) -> Void

protocol OrderService{
    func getOrder(completion: @escaping OrderCompletion)
    func getCurrencies(completion: @escaping CurrenciesCompletion)
    func putOrder(nfts: [String], completion: @escaping OrderPutCompletion)
    func setCurrencyBeforePayment(id: String, completion: @escaping SetCurrencyCompletion)
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
    }

    func getOrder(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request, type: CurrencyValues.self) { result in
            switch result {
            case .success(let currencyValues):
                completion(.success(currencyValues))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putOrder(nfts: [String], completion: @escaping OrderPutCompletion) {
        let dto = OrderDtoObject(nfts: nfts)
        let request = OrderPutRequest(dto: dto)
        
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setCurrencyBeforePayment(id: String, completion: @escaping SetCurrencyCompletion) {
        let request = SetCurrencyRequest(id: id)
        
        networkClient.send(request: request, type: CurrencyPaymentResponse.self) {  result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
