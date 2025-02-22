import Foundation

final class ProfileViewModelImpl: ProfileViewModel {
    var profile = Observable<Profile?>(value: nil)
    var errorModel = Observable<ErrorModel?>(value: nil)
    
    private let profileService: ProfileService
    private let coordinator: ProfileCoordinator
    
    init(profileService: ProfileService, coordinator: ProfileCoordinator) {
        self.profileService = profileService
        self.coordinator = coordinator
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
    
    func presentProfileEditingScreen() {
        guard let profile = profile.value else { return }
        coordinator.profileEditingScene(profile: profile)
    }
    
    func pushMyNftsScreen() {
        guard let profile = profile.value else { return }
        coordinator.myNftsScene(nfts: profile.nfts)
    }
    
    func pushFavouritesScreen() {
        guard let profile = profile.value else { return }
        coordinator.favouritesScene(likes: profile.likes)
    }
    
    func pushAboutDeveloperScreen() {
        guard let profile = profile.value else { return }
        coordinator.webViewScene(url: URL(string: "https://practicum.yandex.ru")!)
    }
    
    func pushUserWebsiteScreen() {
        guard let profile = profile.value else { return }
        coordinator.webViewScene(url: URL(string: profile.website)!)
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
