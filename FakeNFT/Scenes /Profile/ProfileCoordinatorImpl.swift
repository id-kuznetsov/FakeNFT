import UIKit

final class ProfileCoordinatorImpl: ProfileCoordinator {
    private let navigationController: UINavigationController
    private let servicesAssembly: ServicesAssembly
    
    init(navigationController: UINavigationController, servicesAssembly: ServicesAssembly) {
        self.navigationController = navigationController
        self.servicesAssembly = servicesAssembly
    }
    
    func initialScene() {
        let profileService = servicesAssembly.profileService
        let viewModel = ProfileViewModelImpl(profileService: profileService, coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func profileEditingScene(profile: Profile, delegate: ProfileEditingDelegate) {
        guard let profileViewController = navigationController.topViewController as? ProfileViewController else {
            return
        }
        
        let viewModel = ProfileEditingViewModelImpl(profile: profile, coordinator: self)
        viewModel.delegate = delegate
        let profileEditingViewController = ProfileEditingViewController(viewModel: viewModel)
        profileViewController.present(profileEditingViewController, animated: true)
    }
    
    func myNFTsScene(nfts: [String], favourites: [String]) {
        let nftService = servicesAssembly.nftService
        let profileService = servicesAssembly.profileService
        
        let viewModel = MyNFTsViewModelImpl(
            nftIds: nfts, 
            favourites: favourites,
            nftService: nftService,
            profileService: profileService
        )
        
        let myNFTsViewController = MyNFTsViewController(viewModel: viewModel)
        navigationController.pushViewController(myNFTsViewController, animated: true)
    }
    
    func favouritesScene(likes: [String]) {
        let vc = FavouriteNFTsViewController(service: servicesAssembly.nftService, favourites: likes)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func webViewScene(url: URL) {
        let webViewViewController = WebViewViewController(url: url)
        webViewViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewViewController, animated: true)
    }
}
