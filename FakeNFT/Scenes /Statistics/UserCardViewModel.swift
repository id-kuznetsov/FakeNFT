//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import Foundation

protocol UserCardViewModelProtocol {
    var onUserLoaded: ((User) -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var userWebsite: String? { get }
    func loadUserData()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    
    private let userService: UserService
    private let userId: String
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            onUserLoaded?(user)
        }
    }
    
    var userWebsite: String? { user?.website }
    
    var onUserLoaded: ((User) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    init(userService: UserService, userId: String) {
        self.userService = userService
        self.userId = userId
    }
    
    func loadUserData() {
        getUser()
    }
    
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
