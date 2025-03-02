//
//  UserService.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 17.02.2025.
//

import Foundation

protocol UserService {
    func fetchUsers(page: Int, size: Int, completion: @escaping (Result<[User], Error>) -> Void)
    func fetchUser(by id: String, completion: @escaping (Result<User, Error>) -> Void)
    func checkUserWebsite(url: URL, completion: @escaping (Bool) -> Void)
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
        let request = UsersRequest(page: page, size: size)
        
        networkClient.send(request: request, type: [User].self) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser(
        by id: String,
        completion: @escaping (Result<User, Error>
        ) -> Void
    ) {
        let request = UserDetailRequest(id: id)
        
        networkClient.send(request: request, type: User.self) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func checkUserWebsite(url: URL, completion: @escaping (Bool) -> Void) {
        let request = WebsiteAccessRequest(url: url)
        
        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
