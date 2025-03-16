import Foundation

protocol MyNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    var isRefreshing: Observable<Bool> { get }
    var isLoading: Bool { get }
    var errorModel: Observable<ErrorModel?> { get }

    func isLikedNft(at indexPath: IndexPath) -> Bool
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath)
    func refreshNfts()
    func sortNfts(by option: SortOption)
}
