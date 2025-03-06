import Foundation

protocol MyNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    var isRefreshing: Observable<Bool> { get }
    
    func isLikedNft(at indexPath: IndexPath) -> Bool
    func didTapFavouriteButtonOnCell(at indexPath: IndexPath)
    func refreshNfts()
}
