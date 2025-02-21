import UIKit

final class ProfileAssembly {
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    func build() -> UIViewController {
        let viewModel = ProfileViewModelImpl(profileService: profileService)
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
}
