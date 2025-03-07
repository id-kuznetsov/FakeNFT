//
//  CartTableViewCellDelegate.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 25.02.2025.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didTapRemoveButton(with nftId: String, image: UIImage?)
}
