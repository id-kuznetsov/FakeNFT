import Foundation

final class MyNFTsViewModelImpl: MyNFTsViewModel {
    
    // MARK: - Public Properties
    
    let nfts = Observable<[Nft]>(value: [])
    let isRefreshing = Observable<Bool>(value: false)
    var isLoading = true
    
    // MARK: - Private Properties
    
    private var sortOption = SortOption.name
    private var favourites: Set<String>
    private let nftService: NftService
    private let profileService: ProfileService
    
    // MARK: - Init
    
    init(nftIds: [NftID], favourites: [String], nftService: NftService, profileService: ProfileService) {
        self.nftService = nftService
        self.profileService = profileService
        self.favourites = Set(favourites)
        fetchNfts(ids: nftIds)
    }
    
    // MARK: - Public Methods
    
    func isLikedNft(at indexPath: IndexPath) -> Bool {
        guard indexPath.item < nfts.value.count else { return false }
        return favourites.contains(nfts.value[indexPath.item].id)
    }
    
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath) {
        guard indexPath.item < nfts.value.count else { return }
        let nftId = nfts.value[indexPath.item].id
        
        if favourites.contains(nftId) {
            favourites.remove(nftId)
        } else {
            favourites.insert(nftId)
        }
        
        profileService.updateFavouritesNft(favourites: Array(favourites)) { [weak self] result in
            guard let self = self else { return }
            if case .success(let profile) = result {
                self.favourites = Set(profile.likes)
            }
        }
    }
    
    func refreshNfts() {
        isRefreshing.value = true
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.nfts.value = []
                self.favourites = Set(profile.likes)
                self.fetchNfts(ids: profile.nfts)
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
            
            self.isRefreshing.value = false
        }
    }
    
    func sortNfts(by option: SortOption) {
        sortOption = option
        nfts.value = nfts.value.sorted(by: option)
    }
    
    // MARK: - Private Methods
    
    private func fetchNfts(ids: [NftID]) {
        nftService.loadNfts(ids: ids) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                isLoading = false
                let sortedNfts = nfts.sorted(by: sortOption)
                self.nfts.value = sortedNfts
            case .failure(let error):
                print("Failed to load NFTs: \(error)")
            }
        }
    }
}

// MARK: - Sort

private extension Array where Element == Nft {
    func sorted(by option: SortOption) -> Self {
        var sortedArray: Self = []
        switch option {
        case .name:
            sortedArray = self.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .price:
            sortedArray = self.sorted { $0.price > $1.price }
        case .rating:
            sortedArray = self.sorted { $0.rating > $1.rating }
        default:
            break
        }
        return sortedArray
    }
}
