//
//  NftsService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import Foundation

protocol NftsService {
    func loadNfts(completion: @escaping ([NftUI]) -> Void)
}

final class NftsServiceImpl {}

// MARK: - NftsService
extension NftsServiceImpl: NftsService {
    func loadNfts(completion: @escaping ([NftUI]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(NftUI.mock)
        }
    }
}
