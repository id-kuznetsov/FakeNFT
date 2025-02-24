import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private let tokenStorage: TokenStorage
    
    init(networkClient: NetworkClient, tokenStorage: TokenStorage) {
        self.networkClient = networkClient
        self.tokenStorage = tokenStorage
    }
    
    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        guard let token = try? tokenStorage.retrieveToken() else {
            fatalError()
        }
        
        let request = ProfileRequest(token: token)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
