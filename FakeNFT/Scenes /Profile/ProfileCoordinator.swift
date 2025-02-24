import UIKit

protocol ProfileCoordinator {
    func initialScene()
    func profileEditingScene(profile: Profile)
    func myNftsScene(nfts: [String])
    func favouritesScene(likes: [String])
    func webViewScene(url: URL)
}
