//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

final class StatisticsViewModel {
    
    private let servicesAssembly: ServicesAssembly
    private var currentSortOption: SortOption = .name
    
    // MARK: - Properties
    private(set) var users: [User] = []
    private var currentPage = 0
    private let pageSize = 15
    private var isLoading = false
    private var allUsersLoaded = false
    
    var onUsersUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func fetchNextPage() {
        guard !isLoading, !allUsersLoaded else { return }
        
        isLoading = true
        onLoadingStateChanged?(true)
        
        servicesAssembly.userService.fetchUsers(page: currentPage, size: pageSize) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.onLoadingStateChanged?(false)
            
            switch result {
            case .success(let newUsers):
                if newUsers.isEmpty {
                    self.allUsersLoaded = true
                } else {
                    self.users.append(contentsOf: newUsers)
                    self.sortUsers()
                    self.currentPage += 1
                    self.onUsersUpdated?()
                }
            case .failure(let error):
                print("Ошибка загрузки пользователей \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Sorting
    func sortUsers(by option: SortOption? = nil) {
        if let option = option {
            currentSortOption = option
        }
        
        switch currentSortOption {
        case .name:
            users.sort {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() <
                $1.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            }
        case .rating:
            users.sort { (Int($0.rating) ?? 0 > Int($1.rating) ?? 0) }
        default:
            break
        }
        onUsersUpdated?()
    }
}
