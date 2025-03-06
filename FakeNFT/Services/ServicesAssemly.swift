final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let cacheService: CacheService

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        cacheService: CacheService
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.cacheService = cacheService
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var collectionsService: CollectionService {
        CollectionServiceImpl(
            networkClient: networkClient,
            cacheService: cacheService,
            networkMonitor: NetworkMonitorImpl()
        )
    }

    var collectionsSortOptionService: CatalogSortOptionStorage {
        CatalogSortOptionStorageImpl()
    }

    var imageLoaderService: ImageLoaderService {
        ImageLoaderServiceImpl()
    }

//    var userService: UserService {
//        UserServiceImpl()
//    }
}
