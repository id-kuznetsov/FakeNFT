//
//  DeleteViewModel.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 25.02.2025.
//

import UIKit

protocol DeleteViewModelProtocol {
    var image: UIImage { get }
    var deleteNFT: () -> Void { get }
}

final class DeleteViewModel: DeleteViewModelProtocol {

    // MARK: - Public Properties

    let image: UIImage
    let deleteNFT: () -> Void

    // MARK: - Initialisers

    init(image: UIImage, deleteNFT: @escaping () -> Void) {
        self.image = image
        self.deleteNFT = deleteNFT
    }
}
