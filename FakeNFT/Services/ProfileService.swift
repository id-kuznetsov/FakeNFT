import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfileEditingErrorCompletion = (Error) -> Void

protocol ProfileService {
    func fetchProfile(_ completion: @escaping ProfileCompletion)
    func updateAvatar(with avatar: String, _ completion: @escaping ProfileEditingErrorCompletion)
    func updateName(with name: String, _ completion: @escaping ProfileEditingErrorCompletion)
    func updateDescription(with description: String, _ completion: @escaping ProfileEditingErrorCompletion)
    func updateWebsite(with website: String, _ completion: @escaping ProfileEditingErrorCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    private var fetchProfileTask: NetworkTask?
    private var updateAvatarTask: NetworkTask?
    private var updateNameTask: NetworkTask?
    private var updateDescriptionTask: NetworkTask?
    private var updateWebsiteTask: NetworkTask?
    
    func fetchProfile(_ completion: @escaping ProfileCompletion) {
        fetchProfileTask?.cancel()
        let request = ProfileRequest()
        fetchProfileTask = networkClient.send(request: request, type: Profile.self) { [weak self] result in
            self?.fetchProfileTask = nil
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateAvatar(with avatar: String, _ completion: @escaping ProfileEditingErrorCompletion) {
        
    }
    
    func updateName(with name: String, _ completion: @escaping ProfileEditingErrorCompletion) {
        
    }
    
    func updateDescription(with description: String, _ completion: @escaping ProfileEditingErrorCompletion) {
        
    }
    
    func updateWebsite(with website: String, _ completion: @escaping ProfileEditingErrorCompletion) {
        
    }
}
