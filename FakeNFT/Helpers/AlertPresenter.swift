//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 14.02.2025.
//

import UIKit

final class AlertPresenter {
    static func presentAlertWithOneSelection(on viewController: UIViewController,
                                             title: String,
                                             message: String,
                                             actionTitle: String,
                                             preferredStyle: UIAlertController.Style = .alert,
                                             actionCompletion: (() -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionCompletion?()
        }
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
    
    static func presentAlertWithTwoSelections(on viewController: UIViewController,
                                              title: String,
                                              message: String? = nil,
                                              firstActionTitle: String,
                                              firstActionCompletion: (() -> Void)? = nil,
                                              secondActionTitle: String,
                                              secondActionCompletion: (() -> Void)? = nil,
                                              preferredStyle: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let firstAction = UIAlertAction(title: firstActionTitle, style: .default) { _ in
            firstActionCompletion?()
        }
        let secondAction = UIAlertAction(title: secondActionTitle, style: .default) { _ in
            secondActionCompletion?()
        }
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func presentSortAlert(on viewController: UIViewController,
                                 title: String = L10n.Sort.title,
                                 sortOptions: [SortOption],
                                 preferredStyle: UIAlertController.Style = .actionSheet,
                                 sortHandler: @escaping (SortOption) -> Void) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: preferredStyle)
        
        for sortOption in sortOptions {
            let action = UIAlertAction(title: sortOption.title, style: .default) { _ in
                sortHandler(sortOption)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: L10n.Button.close, style: .cancel)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func presentNetworkErrorAlert(
        on viewController: UIViewController,
        retryAction: @escaping () -> Void
    ) {
        let alertController = UIAlertController(
            title: nil,
            message: L10n.Error.fetchingData,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: L10n.Error.repeat, style: .default) { _ in
            retryAction()
        }
        let cancelAction = UIAlertAction(title: L10n.Button.cancel, style: .cancel)
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        alertController.preferredAction = retryAction
        
        viewController.present(alertController, animated: true)
    }
}
