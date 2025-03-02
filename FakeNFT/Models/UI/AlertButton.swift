//
//  AlertButton.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 25.02.2025.
//

enum AlertButton {
    case cancel
    case reload(action: (() -> Void))
    case notNow
    case rate(action: (() -> Void))
    case close
    case back(action: (() -> Void))
    case sortByNftCount(action: (() -> Void))
    case sortByPrice(action: (() -> Void))
    case sortByRating(action: (() -> Void))
    case sortByTitle(action: (() -> Void))
    case sortByName(action: (() -> Void))

    var title: String {
        switch self {
        case .cancel:
            return L10n.Alert.Button.cancel
        case .reload:
            return L10n.Alert.Button.repeat
        case .notNow:
            return L10n.Alert.Button.notNow
        case .rate:
            return L10n.Alert.Button.rate
        case .close:
            return L10n.Alert.Button.close
        case .sortByNftCount:
            return L10n.Alert.Button.sortByNftCount
        case .sortByPrice:
            return L10n.Alert.Button.sortByPrice
        case .sortByRating:
            return L10n.Alert.Button.sortByRating
        case .sortByTitle:
            return L10n.Alert.Button.sortByCollectionName
        case .sortByName:
            return L10n.Alert.Button.sortByUserName
        case .back:
            return L10n.Alert.Button.back
        }
    }

    var style: AlertButtonStyle {
        switch self {
        case .cancel, .close:
            return .cancel
        case .reload, .notNow, .rate, .back,
                .sortByNftCount, .sortByPrice, .sortByRating, .sortByTitle, .sortByName:
            return .default
        }
    }

    var action: (() -> Void)? {
        switch self {
        case .cancel, .notNow, .close:
            return nil
        case .reload(let action),
                .rate(let action),
                .back(let action),
                .sortByNftCount(let action),
                .sortByPrice(let action),
                .sortByRating(let action),
                .sortByTitle(let action),
                .sortByName(let action):
            return action
        }
    }
}

enum AlertButtonStyle {
    case `default`
    case cancel
    case destructive
}
