//
//  UserService.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import Foundation

protocol UserService {
    func fetchUsers(page: Int, size: Int, completion: @escaping (Result<[User], Error>) -> Void)
}

final class UserServiceImpl: UserService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(
        page: Int,
        size: Int,
        completion: @escaping (Result<[User], Error>
        ) -> Void
    ) {
        let request = UserRequest(page: page, size: size)
        
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
