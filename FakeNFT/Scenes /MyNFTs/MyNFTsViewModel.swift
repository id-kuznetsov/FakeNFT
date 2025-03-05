import Foundation

protocol MyNFTsViewModel {
    var nfts: Observable<[Nft]> { get }
    
    func didTapFavouriteButtonOnCell(
        at indexPath: IndexPath,
        _ completion: @escaping (Result<Bool, Error>) -> Void
    )
    
    func didRefresh()
}
