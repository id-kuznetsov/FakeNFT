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
    
    private var selectedCurrencyIndex: Int?
    
    private lazy var leftBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PaymentCollectionViewCell.self)
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
        label.text = L10n.Payment.Agreement.label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var agreementLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Payment.Agreement.link, for: .normal)
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .ypBlack
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Initialisers
    
    init(viewModel: PaymentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setLoadingState(isLoading: true)
        setupBindings()
        viewModel.loadData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
        let agreementVC = AgreementWebViewController()
        navigationController?.pushViewController(agreementVC, animated: true)
    }
    
    @objc
    private func didTapPayButton() {
        // TODO: handle tap pay button
       print("pay")
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel.onItemsUpdate = { [weak self] in
            self?.collectionView.reloadData()
            self?.setLoadingState(isLoading: false)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        title = L10n.Payment.title
        
        view.addSubviews(
            [
                collectionView,
                paymentView,
                payButton,
                userAgreementLabel,
                agreementLinkButton,
                activityIndicator
            ]
        )
        
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setLoadingState(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        let viewsToHide = [
            collectionView,
            paymentView,
            userAgreementLabel,
            agreementLinkButton,
            payButton
        ]
        viewsToHide.forEach { $0.isHidden = isLoading }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            collectionViewConstraints() +
            paymentViewConstraints() +
            payButtonConstraints() +
            userAgreementLabelConstraint() +
            agreementButtonConstraints()
        )
        activityIndicator.constraintCenters(to: view)
    }
    
    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leftInset),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.rightInset),
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
        let item: PaymentCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let card = viewModel.getItem(at: indexPath.item)
        item.configureCell(card: card)
        return item
    }
}

// MARK: UICollectionViewDelegate

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionView.cellForItem(at: indexPath) as? PaymentCollectionViewCell else { return }
        if selectedCurrencyIndex != nil {
            guard let prevIndex = selectedCurrencyIndex,
                  let prevCell = collectionView.cellForItem(at: IndexPath(row: prevIndex, section: 0)) as? PaymentCollectionViewCell else { return }
            prevCell.makeCellSelected(isSelected: false)
        }
        selectedCurrencyIndex = indexPath.item
        item.makeCellSelected(isSelected: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = view.frame.width - Constants.leftInset - Constants.rightInset - Constants.cellSpacing * (CGFloat(Constants.cellCountForRow) - 1)
        let cellWidth = totalWidth / CGFloat(Constants.cellCountForRow)
        return CGSize(width: cellWidth, height: Constants.cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
}

// MARK: Constants

private extension PaymentViewController {
    struct Constants {
        static let cellCountForRow = 2
        static let cellSpacing: CGFloat = 7
        static let cellHeight: CGFloat = 46
        static let leftInset: CGFloat = 16
        static let rightInset: CGFloat = 16
        static let topInset: CGFloat = 20
    }
}
