//
//  SuccessViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 27.02.2025.
//

import UIKit

final class SuccessViewController: UIViewController {

    // MARK: - Private Properties

    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView(image: .success)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.Payment.Success.title
        return label
    }()

    private lazy var returnToCatalogButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Payment.Success.button, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapBackToCatalog), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Action

    @objc
    private func didTapBackToCatalog() {
        dismiss(animated: true, completion: nil)
        guard let tabBarController = presentingViewController as? UITabBarController else {
            return
        }

        tabBarController.selectedIndex = 1
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = .ypWhite

        view.addSubviews(
            [
                successImageView,
                successLabel,
                returnToCatalogButton
            ]
        )

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            successImageViewConstraints() +
            successLabelConstraints() +
            returnToCartButtonConstraints()
        )
    }

    private func successImageViewConstraints() -> [NSLayoutConstraint] {
        [
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278)
        ]
    }

    private func successLabelConstraints() -> [NSLayoutConstraint] {
        [
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ]
    }

    private func returnToCartButtonConstraints() -> [NSLayoutConstraint] {
        [
            returnToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            returnToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            returnToCatalogButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            returnToCatalogButton.heightAnchor.constraint(equalToConstant: 60)
        ]
    }
}
