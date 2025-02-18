//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

final class StatisticsViewModel {
    
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Properties
    private(set) var users: [User] = []
    private var currentPage = 0
    private let pageSize = 10
    private var isLoading = false
    private var allUsersLoaded = false
    
    var onUsersUpdated: (() -> Void)?
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        fetchNextPage()
    }
    
    func fetchNextPage() {
        guard !isLoading, !allUsersLoaded else { return }
        
        isLoading = true
        
        servicesAssembly.userService.fetchUsers(page: currentPage, size: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let newUsers):
                if newUsers.isEmpty {
                    self.allUsersLoaded = true
                } else {
                    self.users.append(contentsOf: newUsers)
                    self.currentPage += 1
                    self.onUsersUpdated?()
                }
            case .failure(let error):
                print("Ошибка загрузки пользователей \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Sorting
    func sortUsers(by option: SortOption) {
        switch option {
        case .name:
            users.sort { $0.name < $1.name }
        case .rating:
            users.sort { $0.rating > $1.rating }
        default:
            break
        }
        onUsersUpdated?()
    }
}
