import Foundation

protocol FavouritesNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    var isRefreshing: Observable<Bool> { get }
    var isLoading: Bool { get }
    var errorModel: Observable<ErrorModel?> { get }
    
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath)
    func refreshNfts()
}
