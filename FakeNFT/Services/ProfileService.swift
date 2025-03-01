import Foundation

typealias ProfileCompletion = (Result<Profile, ProfileServiceError>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion)
}

enum ProfileServiceError: Error {
    case profileFetchingFail
    case profileUpdatingFail
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    private var fetchProfileTask: NetworkTask?
    private var updateProfileTask: NetworkTask?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        fetchProfileTask?.cancel()
        let request = ProfileRequest()
        
        fetchProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.fetchProfileTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(_):
                completion(.failure(.profileFetchingFail))
            }
        }
    }
    
    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion) {
        updateProfileTask?.cancel()
        let request = ProfileEditingRequest(dto: dto)
        
        updateProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.updateProfileTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(_):
                completion(.failure(.profileUpdatingFail))
            }
        }
    }
}
