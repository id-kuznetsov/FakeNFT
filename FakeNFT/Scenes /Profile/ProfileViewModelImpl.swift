import Foundation

final class ProfileViewModelImpl: ProfileViewModel {
    var profile = Observable<Profile?>(value: nil)
    var isLoading = Observable<Bool>(value: true)
    var errorModel = Observable<ErrorModel?>(value: nil)
    
    private let profileService: ProfileService
    private let coordinator: ProfileCoordinator
    
    init(profileService: ProfileService, coordinator: ProfileCoordinator) {
        self.profileService = profileService
        self.coordinator = coordinator
    }
    
    func viewWillAppear() {
        fetchProfile()
    }
    
    func editButtonDidTap() {
        guard let profile = profile.value else { return }
        coordinator.profileEditingScene(profile: profile, delegate: self)
    }
    
    func myNftsCellDidSelect() {
        guard let profile = profile.value else { return }
        coordinator.myNftsScene(nfts: profile.nfts)
    }
    
    func favouritesCellDidSelect() {
        guard let profile = profile.value else { return }
        coordinator.favouritesScene(likes: profile.likes)
    }
    
    func aboutDeveloperCellDidSelect() {
        coordinator.webViewScene(url: DeveloperConstants.url)
    }
    
    func linkButtonDidTap() {
        guard let website = profile.value?.website,
              let url = URL(string: website) else { return }
        coordinator.webViewScene(url: url)
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
    
    private func fetchProfile() {
        isLoading.value = true
        profileService.fetchProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.isLoading.value = false
                self?.profile.value = profile
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
}

extension ProfileViewModelImpl: ProfileEditingDelegate {
    func didEndEditingProfile(_ profileEditingDto: ProfileEditingDto) {
        isLoading.value = true
        profileService.updateProfile(with: profileEditingDto) { [weak self] result in
            switch result {
            case .success:
                self?.fetchProfile()
            case .failure(let error):
                self?.errorModel.value = self?.createErrorModel(with: error)
            }
        }
    }
}
