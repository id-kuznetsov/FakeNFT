import Foundation

protocol MyNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    
    func didTapFavouriteButtonOnCell(
        at indexPath: IndexPath,
        _ completion: @escaping (Bool) -> Void
    )
    
    func didRefresh()
}
