import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let tokenStorage = TokenKeychainStorage()
    
    lazy var servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        tokenStorage: tokenStorage
    )
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        saveUserToken()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tabBar = TabBarController(servicesAssembly: servicesAssembly)
        
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
    func saveUserToken() {
        let token = "1"
        do {
            try tokenStorage.store(token: token)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
