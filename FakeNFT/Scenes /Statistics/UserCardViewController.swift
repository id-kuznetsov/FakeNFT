//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 24.02.2025.
//

import UIKit

final class UserCardViewController: UIViewController {
    
    // MARK: - Private properties
    private var viewModel: UserCardViewModelProtocol
    
    private lazy var customNavBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        return navBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 35
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
        button.layer.cornerRadius = 16
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
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
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
        nftLabelsStackView.spacing = 8
        nftLabelsStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [nftLabelsStackView, chevronImageView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        
        button.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        configureCustomNavBar()
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
    }
    
    private func updateUI(with user: User) {
        nameLabel.text = user.name
        descriptionLabel.text = user.description
        nftCountLabel.text = "(\(user.nfts?.count ?? 0))"
        
        let placeholderImage = UIImage(named: "ic.person.crop.circle.fill") ?? UIImage()
        
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
        
        [customNavBar, avatarImageView, nameLabel, descriptionLabel,
         webViewButton, nftButton].forEach { element in
            view.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            webViewButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            webViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webViewButton.heightAnchor.constraint(equalToConstant: 40),
            
            nftButton.topAnchor.constraint(equalTo: webViewButton.bottomAnchor, constant: 56),
            nftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        setupBindings()
    }
    
    private func configureCustomNavBar() {
        let navItem = UINavigationItem()
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navItem.leftBarButtonItem = backBarButton
        
        customNavBar.setItems([navItem], animated: false)
    }
    
    private func showLoadingIndicator() {
        UIBlockingProgressIndicator.show()
    }
    
    private func hideLoadingIndicator() {
        UIBlockingProgressIndicator.dismiss()
    }
    
    // MARK: - Actions
    @objc private func openUserWebsite() {
        guard let urlString = viewModel.userWebsite, let url = URL(string: urlString) else { return }
        let webVC = WebViewViewController(url: url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc private func getUserCollection() {
        // TO DO: Переход на коллекцию NFT пользователя
        print("Переход на коллекцию NFT пользователя")
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
