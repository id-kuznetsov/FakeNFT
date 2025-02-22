import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        let profileVC = UINavigationController(
            rootViewController: ProfileViewController(servicesAssembly: servicesAssembly)
        )
        profileVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )

        let catalogViewModel = CollectionsViewModel(
            collectionsService: servicesAssembly.collectionsService,
            nftsService: servicesAssembly.nftsService
        )
        let catalogViewController = CollectionsViewController(viewModel: catalogViewModel)
        let catalogNavigationController = CustomNavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(
            title: L10n.Tab.catalog,
            image: .catalogTab,
            tag: 1
        )

        let cartVC = UINavigationController(rootViewController: CartViewController(servicesAssembly: servicesAssembly))
        cartVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )

        let statisticsVC = UINavigationController(
            rootViewController: StatisticsViewController(servicesAssembly: servicesAssembly)
        )
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )

        setViewControllers([profileVC, catalogNavigationController, cartVC, statisticsVC], animated: false)
        self.selectedIndex = 1

        tabBarAppearance()
    }

    private func tabBarAppearance() {
        tabBar.tintColor = .ypBlueUniversal
        tabBar.unselectedItemTintColor = .ypBlack
        tabBar.backgroundColor = .ypWhite
    }
}
