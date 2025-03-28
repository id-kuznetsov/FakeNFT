//
//  CustomNavigationController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 21.02.2025.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)

        if viewController != viewControllers.first {
            let backButton = UIBarButtonItem(
                image: .chevronLeft,
                style: .plain,
                target: self,
                action: #selector(goBack)
            )
            backButton.tintColor = .ypBlack
            viewController.navigationItem.leftBarButtonItem = backButton
        }
    }

    private func setupNavigationBar() {
        let transparentAppearance = UINavigationBarAppearance()
        transparentAppearance.configureWithTransparentBackground()
        transparentAppearance.backgroundColor = .clear
        transparentAppearance.shadowColor = .clear

        navigationBar.standardAppearance = transparentAppearance
        navigationBar.scrollEdgeAppearance = transparentAppearance
    }

    @objc
    private func goBack() {
        popViewController(animated: true)
    }
}
