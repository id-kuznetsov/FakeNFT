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
        let profileVC = UINavigationController(rootViewController: ProfileViewController(servicesAssembly: servicesAssembly))
        profileVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.profile", comment: ""),
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        
        let catalogVC = UINavigationController(rootViewController: CatalogViewController(servicesAssembly: servicesAssembly))
        catalogVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Tab.catalog", comment: ""),
            image: UIImage(systemName: "square.stack.3d.up"),
            selectedImage: UIImage(systemName: "square.stack.3d.up.fill")
        )
        
        let cartViewModel = CartViewModel(
            orderService: servicesAssembly.orderService,
            nftService: servicesAssembly.nftService
            )
        let cartViewController = UINavigationController(rootViewController: CartViewController(viewModel: cartViewModel))
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
        
        setViewControllers([profileVC, catalogVC, cartViewController, statisticsVC], animated: false)
        self.selectedIndex = 2
        
        tabBarAppearance()
    }
    
    private func tabBarAppearance() {
        tabBar.tintColor = .ypBlueUniversal
        tabBar.unselectedItemTintColor = .ypBlack
        tabBar.backgroundColor = .ypWhite
    }
}
