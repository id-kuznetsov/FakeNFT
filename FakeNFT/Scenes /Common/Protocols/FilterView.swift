//
//  FilterView.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 25.02.2025.
//

import UIKit

protocol FilterView {}

extension FilterView where Self: UIViewController {
    func showFilters(
        style: UIAlertController.Style = .actionSheet,
        title: String? = L10n.Alert.Title.sort,
        message: String? = nil,
        buttons: [AlertButton]
    ) {
        let model = AlertModel(
            title: title,
            message: message,
            buttons: buttons,
            style: .actionSheet
        )
        AlertPresenter.showAlert(on: self, model: model)
    }
}
