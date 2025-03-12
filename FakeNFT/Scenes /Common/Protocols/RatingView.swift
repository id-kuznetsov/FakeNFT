//
//  RatingView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 26.02.2025.
//

import UIKit

protocol RatingView {}

extension RatingView where Self: UIViewController {
    func showChangeRating(_ image: UIImage) {
        let model = AlertModel(
            title: nil,
            message: nil,
            buttons: [],
            style: .nftRating
        )
        CatalogAlertPresenter.showChangeNftRatingView(on: self, model: model, image: image)
    }
}
