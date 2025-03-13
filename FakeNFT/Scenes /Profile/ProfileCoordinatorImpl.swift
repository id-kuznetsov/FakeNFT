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

    func profileEditingScene(profile: ProfileDTO, delegate: ProfileEditingDelegate) {
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
        let nftService = servicesAssembly.nftService
        let profileService = servicesAssembly.profileService

        let viewModel = FavouritesNFTsViewModelImpl(
            nftService: nftService,
            profileService: profileService,
            favourites: likes
        )
        let viewController = FavouriteNFTsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func webViewScene(url: URL) {
        let viewModel = WebViewViewModel(url: url)
        let webViewController = WebViewController(viewModel: viewModel)
        webViewController.delegate = self
        webViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewController, animated: true)
    }
}

extension ProfileCoordinatorImpl: WebViewControllerDelegate {
    func webViewControllerDidBack(_ controller: WebViewController) {
        navigationController.popViewController(animated: true)
    }
}
