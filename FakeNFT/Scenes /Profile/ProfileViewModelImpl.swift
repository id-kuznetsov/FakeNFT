import Foundation

final class ProfileViewModelImpl: ProfileViewModel {
    var profile = Observable<Profile?>(value: nil)
    var errorModel = Observable<ErrorModel?>(value: nil)
    
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func fetchProfile() {
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile.value = profile
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
    
    private func createErrorModel(with error: Error) -> ErrorModel {
            let message: String
            switch error {
            case is NetworkClientError:
                message = L10n.Error.network
            default:
                message = L10n.Error.unknown
            }

            let actionText = L10n.Error.repeat
            return ErrorModel(message: message, actionText: actionText) { [weak self] in
                self?.fetchProfile()
            }
        }
}
