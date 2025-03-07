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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
        setupTabs()
    }

    // MARK: - Tabs
    private func setupTabs() {
        let profileVC = UINavigationController(rootViewController: ProfileViewController(servicesAssembly: servicesAssembly))
        profileVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )

        let catalogViewController = TestCatalogViewController(servicesAssembly: servicesAssembly)
        let catalogNavigationController = CustomNavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(
            title: L10n.Tab.catalog,
            image: .catalogTab,
            tag: 2
        )
        
        let cartViewModel = CartViewModel(
            orderService: servicesAssembly.orderService,
            nftService: servicesAssembly.nftService
            )
        let cartViewController = CustomNavigationController(rootViewController: CartViewController(viewModel: cartViewModel))
        cartViewController.tabBarItem = UITabBarItem(
            title: L10n.Tab.cart,
            image: .icCart,
            selectedImage: .icCartFill
        )

        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController(servicesAssembly: servicesAssembly))
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )

        setViewControllers(
            [
                profileVC,
                catalogNavigationController,
                cartViewController,
                statisticsVC
            ],
            animated: false
        )
        self.selectedIndex = 1
    }
    
    // MARK: - Appearance
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlueUniversal
        appearance.stackedLayoutAppearance.normal.iconColor = .ypBlack
        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
