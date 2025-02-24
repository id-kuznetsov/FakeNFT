//
//  StatisticsViewModel.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import UIKit

protocol StatisticsViewModelProtocol {
    var users: [User] { get }
    var onUsersUpdated: (() -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    
    func loadInitialData()
    func fetchNextPage()
    func sortUsers(by option: SortOption?)
    func clearAllStatisticsData()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: - Private properties
    private var userDefaultsStorage: StatisticsUserDefaultsStorageProtocol
    private let cacheStorage: StatisticsCacheStorageProtocol
    private let userService: UserService
    private(set) var users: [User] = []
    private let pageSize = 15
    private var isLoading = false
    private var allUsersLoaded = false
    private var isInitialDataLoaded = false
    
    var onUsersUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    // MARK: - Initializers
    init(
        userService: UserService,
        userDefaultsStorage: StatisticsUserDefaultsStorageProtocol,
        cacheStorage: StatisticsCacheStorageProtocol
    ) {
        self.userService = userService
        self.userDefaultsStorage = userDefaultsStorage
        self.cacheStorage = cacheStorage
    }
    
    // MARK: Public methods
    func loadInitialData() {
        guard !isInitialDataLoaded else { return }
        isInitialDataLoaded = true
        resetPageIfNeeded()
        loadUsersFromCache()
    }
    
    func fetchNextPage() {
        guard !isLoading, !allUsersLoaded else { return }
        
        isLoading = true
        onLoadingStateChanged?(true)
        
        userService.fetchUsers(page: getCurrentPage(), size: pageSize) { [weak self] result in
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
                    self.incrementCurrentPage()
                    self.saveUsersToCache()
                    self.onUsersUpdated?()
                }
            case .failure(let error):
                print("Ошибка загрузки пользователей \(error.localizedDescription)")
            }
        }
    }
    
    func sortUsers(by option: SortOption? = nil) {
        if let option = option {
            saveSelectedSortOption(option)
        }
        
        switch getSelectedSortOption() {
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
    
    // Calling this method on logout (when the authorization functionality will be implemented)
    func clearAllStatisticsData() {
        cacheStorage.clearStatisticsCache()
        userDefaultsStorage.clearStatisticsUserDefaults()
        users.removeAll()
        allUsersLoaded = false
        onUsersUpdated?()
    }
    
    // MARK: Private methods
    private func loadUsersFromCache() {
        if let cachedUsers = cacheStorage.loadUsersFromCache(), !cachedUsers.isEmpty {
            users = cachedUsers
            allUsersLoaded = false
            sortUsers(by: getSelectedSortOption())
            onUsersUpdated?()
        } else {
            userDefaultsStorage.currentPage = 0
            allUsersLoaded = false
            
            fetchNextPage()
        }
    }
    
    private func resetPageIfNeeded() {
        let previousSize = userDefaultsStorage.previousPageSize
        if previousSize != pageSize {
            userDefaultsStorage.currentPage = 0
            userDefaultsStorage.previousPageSize = pageSize
        }
    }
    
    private func saveUsersToCache() {
        cacheStorage.saveUsersToCache(users)
    }
    
    private func getCurrentPage() -> Int {
        return userDefaultsStorage.currentPage
    }
    
    private func incrementCurrentPage() {
        userDefaultsStorage.currentPage += 1
    }
    
    private func getSelectedSortOption() -> SortOption {
        return userDefaultsStorage.selectedUsersSortOption
    }
    
    private func saveSelectedSortOption(_ option: SortOption) {
        userDefaultsStorage.selectedUsersSortOption = option
    }
}
