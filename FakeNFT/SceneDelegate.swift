import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    lazy var servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        cacheService: CacheServiceImpl(),
        networkMonitor: NetworkMonitorImpl()
    )

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        let tabBar = TabBarController(servicesAssembly: servicesAssembly)

        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
}
