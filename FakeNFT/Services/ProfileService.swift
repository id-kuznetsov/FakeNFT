import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion)
}

enum ProfileUpdateField {
    case avatar, name, description, website
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
            completion(result)
        }
    }
    
    func updateProfile(with dto: ProfileEditingDto, _ completion: @escaping ProfileCompletion) {
        updateProfileTask?.cancel()
        let request = ProfileEditingRequest(dto: dto)
        
        updateProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.updateProfileTask = nil
            completion(result)
        }
    }
}
