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
    var userWebsite: String? { get }
    func loadUserData()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    
    // MARK: - Private properties
    private let userService: UserService
    private let userId: String
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            onUserLoaded?(user)
        }
    }
    
    // MARK: - Public properties
    var userWebsite: String? { user?.website }
    
    var onUserLoaded: ((User) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initializers
    init(userService: UserService, userId: String) {
        self.userService = userService
        self.userId = userId
    }
    
    // MARK: Public methods
    func loadUserData() {
        getUser()
    }
    
    // MARK: Private methods
    private func getUser() {
        onLoadingStateChanged?(true)
        userService.fetchUser(by: userId) { [weak self] result in
            self?.onLoadingStateChanged?(false)
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                print("Ошибка загрузки пользователя: \(error.localizedDescription)")
            }
        }
    }
}
