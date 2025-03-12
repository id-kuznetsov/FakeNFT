import UIKit

protocol ProfileCoordinator {
    func initialScene()
    func profileEditingScene(profile: Profile, delegate: ProfileEditingDelegate)
    func myNFTsScene(nfts: [String], favourites: [String])
    func favouritesScene(likes: [String])
    func webViewScene(url: URL)
}
