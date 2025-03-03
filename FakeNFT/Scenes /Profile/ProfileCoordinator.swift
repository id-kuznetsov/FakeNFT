import UIKit

protocol ProfileCoordinator {
    func initialScene()
    func profileEditingScene(profile: Profile, delegate: ProfileEditingDelegate)
    func myNftsScene(nfts: [String])
    func favouritesScene(likes: [String])
    func webViewScene(url: URL)
}
