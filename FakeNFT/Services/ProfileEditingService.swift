import Foundation

typealias ProfileEditingCompletion = (Result<String, Error>) -> Void

protocol ProfileEditingService {
    func updateAvatar(with avatar: String, _ completion: @escaping ProfileEditingCompletion)
    func updateName(with name: String, _ completion: @escaping ProfileEditingCompletion)
    func updateDescription(with description: String, _ completion: @escaping ProfileEditingCompletion)
    func updateWebsite(with website: String, _ completion: @escaping ProfileEditingCompletion)
}


