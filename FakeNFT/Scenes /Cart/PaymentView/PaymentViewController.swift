//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 18.02.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var viewModel: PaymentViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .ypWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .ypLightGrey
        return view
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями" // TODO: local
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var agreementLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal) // TODO: local
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.addTarget(self, action: #selector(didTapAgreementButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Payment.Button.pay, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialisers
    
    init(viewModel: PaymentViewModelProtocol) {
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didTapAgreementButton() {
        // TODO: handle tap pay button
        print("agreement")
    }
    
    @objc
    private func didTapPayButton() {
        // TODO: handle tap pay button
        print("pay")
    }
    
    // MARK: - Private Methods
    
    func setupUI() {
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .ypWhite
        
        view.addSubviews([paymentView, payButton, userAgreementLabel, agreementLinkButton])
        
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = L10n.Payment.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
//            collectionViewConstraints()
            paymentViewConstraints() +
            payButtonConstraints() +
            userAgreementLabelConstraint() +
            agreementButtonConstraints()
        )
    }
    
    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
    
    private func paymentViewConstraints() -> [NSLayoutConstraint] {
        [
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 186)
        ]
    }
    
    private func userAgreementLabelConstraint() -> [NSLayoutConstraint] {
        [
            userAgreementLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            userAgreementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userAgreementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userAgreementLabel.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -42)
        ]
    }
    
    private func agreementButtonConstraints() -> [NSLayoutConstraint] {
        [
            agreementLinkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            agreementLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agreementLinkButton.topAnchor.constraint(equalTo: userAgreementLabel.bottomAnchor),
            agreementLinkButton.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -16)
        ]
    }
    
    private func payButtonConstraints() -> [NSLayoutConstraint] {
        [
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60)
        ]
    }
}

// MARK: - Extensions
// MARK: UICollectionViewDataSource

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.paymentMethodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = UICollectionViewCell()
        return item
    }
    
    
}

extension PaymentViewController: UICollectionViewDelegate {}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    
}
