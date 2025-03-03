final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var collectionsService: CollectionService {
        CollectionServiceImpl(
            networkClient: networkClient
        )
    }

    var collectionsSortOptionService: CollectionsSortOptionStorageService {
        CollectionsSortOptionStorageServiceImpl()
    }

    var nftsService: NftsService {
        NftsServiceImpl()
    }

    var imageLoaderService: ImageLoaderService {
        ImageLoaderServiceImpl()
    }

    var userService: UserService {
        UserServiceImpl()
    }
}
