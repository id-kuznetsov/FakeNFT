//
//  UserService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

//import Foundation
//
//protocol UserService {
//    func fetchUsers(completion: @escaping ([UserUI]) -> Void)
//}
//
//final class UserServiceImpl {}
//
//// MARK: - UserService
//extension UserServiceImpl: UserService {
//    func fetchUsers(completion: @escaping ([UserUI]) -> Void) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(UserUI.mock)
//        }
//    }
//}
//
//// MARK: - Mock
//extension UserUI {
//    static var mock: [UserUI] {
//        [
//            UserUI(
//                name: "Barry Sheppard",
//                avatar: URL(string: "https://practicum.yandex.ru/ios-developer/"),
//                description: "iOS Developer",
//                website: URL(string: "https://practicum.yandex.ru/ios-developer/"),
//                nfts: ["1", "2", "3"],
//                rating: "4",
//                id: "1"
//            ),
//            UserUI(
//                name: "Harold Chapman",
//                avatar: URL(string: "https://exempele.net/"),
//                description: "Harold Chapman",
//                website: URL(string: "https://exempele.net/"),
//                nfts: ["1", "2", "3"],
//                rating: "4",
//                id: "2"
//            ),
//            UserUI(
//                name: "Lourdes Harper",
//                avatar: URL(string: "https://yandex.ru/"),
//                description: "Lourdes Harper",
//                website: URL(string: "https://yandex.ru/"),
//                nfts: ["1", "2", "3"],
//                rating: "4",
//                id: "3"
//            )
//        ]
//    }
//}
