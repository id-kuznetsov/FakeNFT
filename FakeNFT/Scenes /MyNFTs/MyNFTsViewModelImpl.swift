import Foundation

final class MyNFTsViewModelImpl: MyNFTsViewModel {
    
    // MARK: - Public Properties
    
    let nfts: Observable<[Nft]> = Observable(value: [])
    
    // MARK: - Private Properties
    
    private let nftService: NftService
    private let profileService: ProfileService
    
    // MARK: - Init
    
    init(nftIds: [NftID], nftService: NftService, profileService: ProfileService) {
        self.nftService = nftService
        self.profileService = profileService
        fetchNfts(ids: nftIds)
    }
    
    // MARK: - Public Methods
    
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    func didRefresh() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.nfts.value = []
                self?.fetchNfts(ids: profile.nfts)
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchNfts(ids: [NftID]) {
        for id in ids {
            nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.value += [nft]
                case .failure:
                    assertionFailure("Failed to load nft with id: \(id)")
                }
            }
        }
    }
}
