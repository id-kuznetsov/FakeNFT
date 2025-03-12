final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let cacheService: CacheService
    private let networkMonitor: NetworkMonitor

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        cacheService: CacheService,
        networkMonitor: NetworkMonitor
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.cacheService = cacheService
        self.networkMonitor = networkMonitor
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    

    var profileService: ProfileService {
        ProfileServiceImpl(networkClient: networkClient)
    }

    var userService: UserService {
        UserServiceImpl(
            networkClient: networkClient
        )
    }
    
    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient
        )
    }

    var collectionsService: CollectionService {
        CollectionServiceImpl(
            networkClient: networkClient,
            cacheService: cacheService,
            networkMonitor: networkMonitor
        )
    }

    var collectionNftService: CollectionNftService {
        CollectionNftServiceImpl(
            networkClient: networkClient,
            cacheService: cacheService,
            networkMonitor: networkMonitor
        )
    }

    var orderService: OrderService {
        OrderServiceImpl(
            networkClient: networkClient,
            cacheService: cacheService,
            networkMonitor: networkMonitor
        )
    }

    var profileService: ProfileService {
        ProfileServiceImpl(
            networkClient: networkClient,
            cacheService: cacheService,
            networkMonitor: networkMonitor
        )
    }

    var collectionsSortOptionService: CollectionsSortOptionStorage {
        CollectionsSortOptionStorageImpl()
    }

    var imageLoaderService: ImageLoaderService {
        ImageLoaderServiceImpl()
    }
}
