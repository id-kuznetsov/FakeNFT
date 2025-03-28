//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 15.02.2025.
//

import Foundation

final class CartViewModel: CartViewModelProtocol {

    // MARK: - Public Properties

    let orderService: OrderService
    var onItemsUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var itemsCount: Int {
        nftsInCart.count
    }
    var isCartEmpty: Bool {
        nftsInCart.isEmpty
    }

    // MARK: - Private Properties

    private let nftService: NftService
    private var nftsInCart: [OrderCard] = []
    private let sortStorage = SortStateStorage.shared

    // MARK: - Initialisers

    init(orderService: OrderService, nftService: NftService ) {
        self.orderService = orderService
        self.nftService = nftService
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cartUpdated),
            name: .cartUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .cartUpdated, object: nil)
    }

    // MARK: - Public Methods

    func getItem(at index: Int) -> OrderCard {
        nftsInCart[index]
    }

    func getTotalCost() -> Double {
        nftsInCart.reduce(0, { $0 + $1.price})
    }

    func loadData() {
        orderService.getOrder(completion: { [weak self] result in
            switch result {
            case .success(let order):
                self?.loadNFTs(by: order.nfts)

            case .failure(let error):
                print("Error: \(error) in \(#function) \(#file)")
                self?.onError?(error.localizedDescription)
            }
        })
    }

    func sortItems(by sortOption: SortOption) {
        sortStorage.sortOptionInCart = sortOption.title
        switch sortOption {
        case .name:
            nftsInCart.sort { $0.name < $1.name }
        case .price:
            nftsInCart.sort { $0.price < $1.price }
        case .rating:
            nftsInCart.sort { $0.rating > $1.rating }
        default:
            break
        }
        onItemsUpdate?()
    }

    func deleteItem(with nftId: String) {
        let updatedNftIds = nftsInCart
            .map { $0.id }
            .filter { $0 != nftId }

        orderService.putOrder(nfts: updatedNftIds) { [weak self] result in
            switch result {
            case .success(let order):
                self?.loadNFTs(by: order.nfts)
            case .failure(let error):
                assertionFailure("Error: \(error) in \(#function) \(#file)")
                self?.onError?(error.localizedDescription)
            }

        }
    }

    func clearCart() {
        orderService.putOrder(nfts: []) { [weak self] result in
            switch result {
            case .success(let order):
                self?.loadNFTs(by: order.nfts)
            case .failure(let error):
                assertionFailure("Error: \(error) in \(#function) \(#file)")
                self?.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: - Private Methods
    @objc
    private func cartUpdated() {
        loadData()
        onItemsUpdate?()
    }

    private func loadNFTs(by ids: [String]) {
        let group = DispatchGroup()
        var loadedNFTs: [OrderCard] = []

        for id in ids {
            group.enter()
            nftService.loadNft(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    defer { group.leave() }

                    switch result {
                    case .success(let nft):
                        guard let url = nft.images.first else {
                            assertionFailure("Unable to get image URL in \(#function) \(#file)")
                            return
                        }
                        let orderCard = OrderCard(
                            id: nft.id,
                            name: nft.name,
                            rating: nft.rating,
                            price: nft.price,
                            imageURL: url
                        )
                        loadedNFTs.append(orderCard)
                    case .failure(let error):
                        assertionFailure("Error loading NFT: \(error.localizedDescription) \(#function) \(#file)")
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.nftsInCart = loadedNFTs
            self?.onItemsUpdate?()
            self?.applyLastSortOption()
        }
    }

    private func applyLastSortOption() {
        guard let lastSortOptionTitle = sortStorage.sortOptionInCart,
              let lastSortOption = SortOption.allCases.first(where: { $0.title == lastSortOptionTitle }) else {
            return
        }
        sortItems(by: lastSortOption)
    }
}
