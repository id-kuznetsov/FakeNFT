//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 25.02.2025.
//

enum AlertStyle {
    case alert
    case filter
    case nftRating
}

struct AlertModel {
    let title: String?
    let message: String?
    let buttons: [AlertButton]
    let style: AlertStyle

    init(
        title: String?,
        message: String?,
        buttons: [AlertButton],
        style: AlertStyle = .alert
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
        self.style = style
    }
}
