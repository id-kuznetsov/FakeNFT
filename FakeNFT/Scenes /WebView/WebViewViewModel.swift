//
//  WebViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

import Foundation
import Combine

protocol WebViewViewModelProtocol {
    func authorRequest() async throws -> URLRequest
}

enum WebViewViewModelError: Error {
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

final class WebViewViewModel {
//    private let userService: UserService
    private let authorName: String

    // MARK: - Init
    init(
//        userService: UserService,
        authorName: String
    ) {
//        self.userService = userService
        self.authorName = authorName

    }

//    private func getUsers() async -> [UserUI] {
//        return await withCheckedContinuation { continuation in
//            userService.fetchUsers { items in
//                continuation.resume(returning: items)
//            }
//        }
//    }

//    private func getCollectionAuthorUrl() async throws -> URL {
//        let users = await getUsers()
//
//        guard let user = users.first(where: { $0.name == authorName }),
//              let website = user.website else {
//            throw WebViewViewModelError.authorNotFound
//        }
//        return website
//    }
}

// MARK: - WebViewViewModelProtocol
// extension WebViewViewModel: WebViewViewModelProtocol {
//    func authorRequest() async throws -> URLRequest {
//        let url = try await getCollectionAuthorUrl()
//        return URLRequest(url: url)
//    }
// }
