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
        let profileNavigationController = CustomNavigationController()
        profileNavigationController.tabBarItem = UITabBarItem(title: L10n.Tab.profile,
                                                              image: .icTabProfile,
                                                              selectedImage: nil)
        let profileCoordinator = ProfileCoordinatorImpl(navigationController: profileNavigationController,
                                                        servicesAssembly: servicesAssembly)
        profileCoordinator.initialScene()

        let collectionsServiceAssembly = CollectionsServiceAssembly(servicesAssembler: servicesAssembly)
        let catalogViewController = collectionsServiceAssembly.build()
        let catalogNavigationController = CustomNavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = UITabBarItem(title: L10n.Tab.catalog,
                                                              image: .catalogTab,
                                                              selectedImage: nil)

        let cartViewModel = CartViewModel(orderService: servicesAssembly.orderService,
                                          nftService: servicesAssembly.nftService)
        let cartViewController = CustomNavigationController(
            rootViewController: CartViewController(viewModel: cartViewModel)
        )
        cartViewController.tabBarItem = UITabBarItem(title: L10n.Tab.cart,
                                                     image: .icCartFill,
                                                     selectedImage: nil)

        let statisticsViewModel = StatisticsViewModel(
            userService: servicesAssembly.userService,
            nftService: servicesAssembly.nftService,
            orderService: servicesAssembly.orderService,
            userDefaultsStorage: StatisticsUserDefaultsStorage(),
            cacheStorage: StatisticsCacheStorage()
        )
        let statisticsVC = StatisticsViewController(viewModel: statisticsViewModel)
        let statisticsNavigationController = CustomNavigationController(rootViewController: statisticsVC)
        statisticsNavigationController.tabBarItem = UITabBarItem(
            title: L10n.Tab.statistic,
            image: .icStatisticsFill,
            selectedImage: nil
        )

        setViewControllers(
            [
                profileNavigationController,
                catalogNavigationController,
                cartViewController,
                statisticsNavigationController
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

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlack,
            .font: UIFont.caption4
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.ypBlueUniversal,
            .font: UIFont.caption4
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlueUniversal
        appearance.stackedLayoutAppearance.normal.iconColor = .ypBlack
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
