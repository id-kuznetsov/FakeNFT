import Foundation

final class MyNFTsViewModelImpl: MyNFTsViewModel {
    
    // MARK: - Public Properties
    
    let nfts: Observable<[Nft]> = Observable(value: [])
    let isRefreshing: Observable<Bool> = Observable(value: false)
    
    // MARK: - Private Properties
    
    private var favourites: [String] = []
    private let nftService: NftService
    private let profileService: ProfileService
    
    // MARK: - Init
    
    init(nftIds: [NftID], favourites: [String], nftService: NftService, profileService: ProfileService) {
        self.nftService = nftService
        self.profileService = profileService
        self.favourites = favourites
        fetchNfts(ids: nftIds)
    }
    
    // MARK: - Public Methods
    
    func isLikedNft(at indexPath: IndexPath) -> Bool {
        guard indexPath.item < nfts.value.count else {
            return false
        }
        
        let nftId = nfts.value[indexPath.item].id
        return favourites.contains(where: { $0 == nftId })
    }
    
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath) {
        if isLikedNft(at: indexPath) {
            favourites = favourites.filter { $0 != nfts.value[indexPath.item].id }
        } else {
            favourites = favourites + [nfts.value[indexPath.item].id]
        }
        
        profileService.updateFavouritesNft(favourites: favourites) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.favourites = profile.likes
            case .failure(_):
                break
            }
        }
    }
    
    func refreshNfts() {
        isRefreshing.value = true
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.nfts.value = []
                self?.favourites = profile.likes
                self?.fetchNfts(ids: profile.nfts)
            case .failure:
                break
            }
            self?.isRefreshing.value = false
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchNfts(ids: [NftID]) {
        nftService.loadNfts(ids: ids) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.nfts.value = nfts
            case .failure:
                break
            }
        }
    }
}
