//
//  UserWebViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

import Foundation
import Combine

protocol UserWebViewModelProtocol {
//    var users: [UserUI] { get }
//    var usersPublisher: Published<[UserUI]>.Publisher { get }
    func authorRequest() async throws -> URLRequest
}

enum UserWebViewModelError: Error {
    case authorNotFound
    case authorUrlEmpty

    var authorNotFound: String {
        switch self {
        case .authorNotFound:
            return "Не удалось найти автора."
        case .authorUrlEmpty:
            return "Ссылка на страницу автора пуста."
        }
    }
}

final class UserWebViewModel: UserWebViewModelProtocol {
//    @Published var users = [UserUI]()
//    var usersPublisher: Published<[UserUI]>.Publisher { $users }

    private let userService: UserService
    private let authorName: String

    // MARK: - Init
    init(
        userService: UserService,
        authorName: String
    ) {
//        self.users = []
        self.userService = userService
        self.authorName = authorName

//        userService.fetchUsers { users in
//            self.users = users
//        }
    }

    func authorRequest() async throws -> URLRequest {
        let url = try await getCollectionAuthorUrl()
        return URLRequest(url: url)
    }

    private func getUsers() async -> [UserUI] {
        return await withCheckedContinuation { continuation in
            userService.fetchUsers { items in
                continuation.resume(returning: items)
            }
        }
    }

    private func getCollectionAuthorUrl() async throws -> URL {
        let users = await getUsers()

        guard let user = users.first(where: { $0.name == authorName }),
              let website = user.website else {
            throw UserWebViewModelError.authorNotFound
        }
        return website
    }
}
