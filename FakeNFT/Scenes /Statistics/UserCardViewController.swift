//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import UIKit
import SafariServices

final class UserCardViewController: UIViewController {
    
    // MARK: - Private properties
    private var viewModel: UserCardViewModelProtocol
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.chevronLeft, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = StatisticsConstants.Common.cornerRadiusBig
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .headline3
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.font = .caption2
        return label
    }()
    
    private lazy var webViewButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.UserCard.websiteButton, for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .caption1
        button.layer.cornerRadius = StatisticsConstants.Common.cornerRadiusXHight
        button.layer.borderColor = UIColor.ypBlack.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(openUserWebsite), for: .touchUpInside)
        return button
    }()
    
    private lazy var nftLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.UserCard.nftCollectionLabel
        label.textColor = .ypBlack
        label.font = .bodyBold
        return label
    }()
    
    private lazy var nftCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .bodyBold
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: (UIImage.chevronRight))
        imageView.tintColor = .ypBlack
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(getUserCollection), for: .touchUpInside)
        
        let nftLabelsStackView = UIStackView(arrangedSubviews: [nftLabel, nftCountLabel])
        nftLabelsStackView.axis = .horizontal
        nftLabelsStackView.spacing = StatisticsConstants.UserCardVc.MainScreen.nftButtonSpacing
        nftLabelsStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [nftLabelsStackView, chevronImageView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = StatisticsConstants.UserCardVc.MainScreen.nftButtonSpacing
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        
        button.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: button.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        return button
    }()
    
    // MARK: - Lifesycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.loadUserData()
    }
    
    // MARK: - Initializers
    init(viewModel: UserCardViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupBindings() {
        viewModel.onUserLoaded = { [weak self] user in
            DispatchQueue.main.async {
                self?.updateUI(with: user)
            }
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        }
        
        viewModel.onErrorOccurred = { [weak self] _ in
            DispatchQueue.main.async {
                self?.showNetworkErrorAlert()
            }
        }
    }
    
    private func updateUI(with user: User) {
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        nftCountLabel.text = "(\(user.nfts?.count ?? 0))"
        
        let placeholderImage = UIImage.profileTab?.withTintColor(.ypGrayUniversal, renderingMode: .alwaysOriginal) ?? UIImage()
        
        if let avatarUrl = user.avatar, let url = URL(string: avatarUrl) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
        // Hide button if user doesn't have website
        webViewButton.isHidden = viewModel.userWebsite == nil
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        [avatarImageView, nameLabel, descriptionLabel,
         webViewButton, nftButton].forEach { element in
            view.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: StatisticsConstants.UserCardVc.MainScreen.avatarLeftInset
            ),
            avatarImageView.widthAnchor.constraint(
                equalToConstant: StatisticsConstants.UserCardVc.MainScreen.avatarWidth
            ),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: StatisticsConstants.UserCardVc.MainScreen.nameLabelLeftInset
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: StatisticsConstants.UserCardVc.MainScreen.descriptionTopInset
            ),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -StatisticsConstants.UserCardVc.MainScreen.descriptionRightInset
            ),
            
            webViewButton.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: StatisticsConstants.UserCardVc.MainScreen.webViewButtonTopInset
            ),
            webViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webViewButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            webViewButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            webViewButton.heightAnchor.constraint(
                equalToConstant: StatisticsConstants.UserCardVc.MainScreen.webViewButtonHeight
            ),
            
            nftButton.topAnchor.constraint(
                equalTo: webViewButton.bottomAnchor,
                constant: StatisticsConstants.UserCardVc.MainScreen.nftButtonTopInset),
            nftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nftButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            nftButton.heightAnchor.constraint(equalTo: webViewButton.heightAnchor)
        ])
        
        setupBindings()
    }
    
    private func showNetworkErrorAlert() {
        AlertPresenter.presentNetworkErrorAlert(on: self) { [weak self] in
            self?.viewModel.loadUserData()
        }
    }
    
    private func showInaccessibleWebsiteAlert() {
        AlertPresenter.presentAlertWithOneSelection(
            on: self,
            title: L10n.Error.title,
            message: L10n.UserCard.websiteInaccessible,
            actionTitle: L10n.Button.ok
        )
    }
    
    private func showLoadingIndicator() {
        UIBlockingProgressIndicator.show()
    }
    
    private func hideLoadingIndicator() {
        UIBlockingProgressIndicator.dismiss()
    }
    
    // MARK: - Actions
    @objc private func openUserWebsite() {
        viewModel.checkUserWebsite { [weak self] isAccessible in
            guard let self = self else { return }
            
            if isAccessible {
                guard let urlString = self.viewModel.userWebsite, let url = URL(string: urlString) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredControlTintColor = .ypBlack
                safariVC.preferredBarTintColor = .ypWhite
                safariVC.modalPresentationStyle = .overFullScreen
                safariVC.delegate = self
                
                present(safariVC, animated: true)
            } else {
                showInaccessibleWebsiteAlert()
            }
        }
    }
    
    @objc private func getUserCollection() {
        let collectionViewModel = viewModel.createUserCollectionViewModel()
        let collectionVC = UserNftCollectionViewController(viewModel: collectionViewModel)
        
        navigationController?.pushViewController(collectionVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension UserCardViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
