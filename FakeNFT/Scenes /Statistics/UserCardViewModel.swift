//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import Foundation

protocol UserCardViewModelProtocol {
    var onUserLoaded: ((User) -> Void)? { get set }
    var user: User? { get }
    func loadUserData()
}

final class UserCardViewModel: UserCardViewModelProtocol {
    
    private let userService: UserService
    private let userId: String
    
    var onUserLoaded: ((User) -> Void)?
    private(set) var user: User? {
        didSet {
            guard let user = user else { return }
            onUserLoaded?(user)
        }
    }
    
    init(userService: UserService, userId: String) {
        self.userService = userService
        self.userId = userId
    }
    
    func loadUserData() {
        getUser()
    }
    
    private func getUser() {
        userService.fetchUser(by: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure(let error):
                print("Ошибка загрузки пользователя: \(error.localizedDescription)")
            }
        }
    }
}
