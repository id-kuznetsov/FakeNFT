//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import Foundation

// MARK: - UserCardViewModelProtocol
protocol UserCardViewModelProtocol {
    var onUserLoaded: ((User) -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onErrorOccurred: ((String) -> Void)? { get set }
    var userWebsite: String? { get }
    var nftIds: [String] { get }
    func loadUserData()
    func checkUserWebsite(completion: @escaping (Bool) -> Void)
    func createUserCollectionViewModel() -> UserNftCollectionViewModelProtocol
}

final class UserCardViewModel: UserCardViewModelProtocol {

    // MARK: - Public properties
    var userWebsite: String? { user?.website }
    var onUserLoaded: ((User) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onErrorOccurred: ((String) -> Void)?
    var nftIds: [String] = []

    // MARK: - Private properties
    private let userService: UserService
    private let nftService: NftService
    private let orderService: OrderService
    private let userId: String

    private var user: User? {
        didSet {
            guard let user = user else { return }
            self.nftIds = user.nfts ?? []
            onUserLoaded?(user)
        }
    }

    // MARK: - Initializers
    init(
        userService: UserService,
        nftService: NftService,
        orderService: OrderService,
        userId: String,
        nftIds: [String]
    ) {
        self.userService = userService
        self.nftService = nftService
        self.orderService = orderService
        self.userId = userId
        self.nftIds = nftIds
    }

    // MARK: Public methods
    func loadUserData() {
        getUser()
    }

    func createUserCollectionViewModel() -> UserNftCollectionViewModelProtocol {
        return UserNftCollectionViewModel(
            nftService: nftService,
            userService: userService,
            orderService: orderService,
            userId: userId,
            nftIds: nftIds
        )
    }

    func checkUserWebsite(completion: @escaping (Bool) -> Void) {
        guard let urlString = userWebsite, let url = URL(string: urlString) else {
            completion(false)
            return
        }

        userService.checkUserWebsite(url: url, completion: completion)
    }

    // MARK: Private methods
    private func getUser() {
        onLoadingStateChanged?(true)
        userService.fetchUser(by: userId) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChanged?(false)

            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                self.onErrorOccurred?("Не удалось получить данные \(error.localizedDescription)")
            }
        }
    }
}
