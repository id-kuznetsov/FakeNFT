import Foundation

final class FavouritesNFTsViewModelImpl: FavouritesNFTsViewModel {
    var nfts: Observable<[Nft]>
    var isRefreshing: Observable<Bool>
    var errorModel: Observable<ErrorModel?>
    var isLoading = true

    private let nftService: NftService
    private let profileService: ProfileService
    private var favourites: Set<NftID>

    init(nftService: NftService, profileService: ProfileService, favourites: [NftID]) {
        self.nftService = nftService
        self.profileService = profileService
        self.favourites = Set(favourites)
        nfts = Observable(value: [])
        isRefreshing = Observable(value: false)
        errorModel = Observable(value: nil)
        fetchFavourites()
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
                favourites = Set(profile.likes)
                fetchFavourites()
            }
        }
    }

    func refreshNfts() {
        isRefreshing.value = true
        profileService.fetchProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                nfts.value = []
                favourites = Set(profile.likes)
                fetchFavourites()
            case .failure(let error):
                errorModel.value = createErrorModel(with: error)
            }

            self.isRefreshing.value = false
        }
    }

    private func fetchFavourites() {
        nftService.loadNfts(ids: Array(favourites)) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.isLoading = false

                let sortedNfts = nfts.sorted(by: { $0.name < $1.name })
                self?.nfts.value = sortedNfts
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }

    private func createErrorModel(with error: Error) -> ErrorModel {
        switch error {
        case ProfileServiceError.profileFetchingFail:
            return ErrorModel(
                message: L10n.Error.update,
                actionText: L10n.Button.close,
                action: { }
            )

        case is NetworkClientError:
            return ErrorModel(
                message: L10n.Error.network,
                actionText: L10n.Button.close,
                action: { }
            )

        default:
            return ErrorModel(
                message: L10n.Profile.unknownError,
                actionText: L10n.Button.close,
                action: { }
            )
        }
    }
}
