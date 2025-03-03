//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 24.02.2025.
//

import UIKit

final class DeleteViewController: UIViewController {
    
    private let viewModel: DeleteViewModelProtocol
    
    // MARK: - Private Properties
    
    private lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var conformationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = L10n.Cart.Delete.conformText
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Cart.Delete.buttonDelete, for: .normal)
        button.tintColor = .ypRedUniversal
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Cart.Delete.buttonReturn, for: .normal)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deleteButton, returnButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView(frame: view.frame)
        return view
    }()
    
    // MARK: - Initialisers
    
    init(viewModel: DeleteViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Action
    
    @objc
    private func didTapDeleteButton() {
        dismiss(animated: true) { [weak self] in
            self?.viewModel.deleteNFT()
        }
    }
    
    @objc
    private func didTapReturnButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        nftImageView.image = viewModel.image
    }
    
    private func setupUI() {
        view.addSubviews(
            [
                blurView,
                contentView,
                nftImageView,
                conformationLabel,
                buttonsStackView
            ]
        )
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            contentViewConstraints() +
            nftImageViewConstraints() +
            conformationLabelConstraints() +
            buttonsConstraints()
        )
        contentView.constraintCenters(to: view)
    }
    private func contentViewConstraints() -> [NSLayoutConstraint] {
        [
            contentView.heightAnchor.constraint(equalToConstant: 220),
            contentView.widthAnchor.constraint(equalToConstant: 262)
        ]
    }
    private func nftImageViewConstraints() -> [NSLayoutConstraint] {
        [
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)
        ]
    }
    
    private func conformationLabelConstraints() -> [NSLayoutConstraint] {
        [
            conformationLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            conformationLabel.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor, constant: 41),
            conformationLabel.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor, constant: -41),
            conformationLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -20)
        ]
    }
    private func buttonsConstraints() -> [NSLayoutConstraint] {
        [
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 56),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -56)
        ]
    }
}
