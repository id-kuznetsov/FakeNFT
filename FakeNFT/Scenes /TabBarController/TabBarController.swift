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
        let profileNavigationController = NavigationController()
        let profileTabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: .icTabProfile,
            selectedImage: .icTabProfile
        )
        profileNavigationController.tabBarItem = profileTabBarItem
        let profileCoordinator = ProfileCoordinatorImpl(navigationController: profileNavigationController,
                                                    servicesAssembly: servicesAssembly)
        profileCoordinator.initialScene()
        
        let catalogVC = UINavigationController(rootViewController: CatalogViewController(servicesAssembly: servicesAssembly))
        catalogVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.3d.up"),
            selectedImage: UIImage(systemName: "square.stack.3d.up.fill")
        )
        
        let cartVC = UINavigationController(rootViewController: CartViewController(servicesAssembly: servicesAssembly))
        cartVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.cart", comment: ""),
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        
        let statisticsVC = UINavigationController(rootViewController: StatisticsViewController(servicesAssembly: servicesAssembly))
        statisticsVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        
        setViewControllers([profileNavigationController, catalogVC, cartVC, statisticsVC], animated: false)
        self.selectedIndex = 1
        
        tabBarAppearance()
    }
    
    private func tabBarAppearance() {
        tabBar.tintColor = .ypBlueUniversal
        tabBar.unselectedItemTintColor = .ypBlack
        tabBar.backgroundColor = .ypWhite
    }
}
