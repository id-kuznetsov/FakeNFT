//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import Foundation

final class CartViewModel: CartViewModelProtocol {
    
    // MARK: - Public Properties
    
    var onItemsUpdate: (() -> Void)?
    var itemsCount: Int {
        nftsInCart.count
    }
    
    // MARK: - Private Properties
    
    private let servicesAssembly: ServicesAssembly
    private var nftsInCart: [OrderCard] = []
    
    // MARK: - Initialisers
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Methods
    
    func getItem(at index: Int) -> OrderCard {
        nftsInCart[index]
    }
    
    func getTotalCost() -> Double {
        nftsInCart.reduce(0, { $0 + $1.price})
    }
    
    func loadData() {
        servicesAssembly.orderService.getOrder(completion: { [weak self] result in
            switch result {
            case .success(let order):
                self?.loadNFTs(by: order.nfts)
                
            case .failure(let error):
                print("Error: \(error) in \(#function) \(#file)")
            }
        })
    }
    
    // MARK: - Private Methods
    
    private func loadNFTs(by ids: [String]) {
        let group = DispatchGroup()
        var loadedNFTs: [OrderCard] = []
        
        for id in ids {
            group.enter()
            servicesAssembly.nftService.loadNft(id: id) { result in
                DispatchQueue.main.async {
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let nft):
                        guard let url = nft.images.first else {
                            print("Unable to get image URL in \(#function) \(#file)")                    
                            return
                        }
                        let orderCard = OrderCard(
                            name: nft.name,
                            rating: nft.rating,
                            price: nft.price,
                            imageURL: url
                        )
                        loadedNFTs.append(orderCard)
                    case .failure(let error):
                        print("Ошибка загрузки NFT: \(error.localizedDescription) \(#function) \(#file)")
                        // TODO: в cart-3 передать ошибку через алерт
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.nftsInCart = loadedNFTs
            self?.onItemsUpdate?()
        }
    }
}
