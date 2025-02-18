//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetesov on 13.02.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var viewModel: CartViewModelProtocol
    
    private lazy var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: .icFilter,
            style: .done,
            target: self,
            action: #selector(didTapSortButton)
        )
        return barButtonItem
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.rowHeight = Constants.tableViewRowHeight
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrey
        return view
    }()
    
    private lazy var totalNFTCountInOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textColor = .ypGreenUniversal
        label.textAlignment = .left
        return label
    }()
    
    private lazy var paymentButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Cart.Button.toPay, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapPaymentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .ypBlack
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Initialisers
    
    init(viewModel: CartViewModelProtocol) {
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
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSortButton() {
        AlertPresenter.presentSortAlert(
            on: self,
            sortOptions: [.price, .rating, .name]
        ) { [weak self] selectedSortOption in
            switch selectedSortOption {
            case .price:
                self?.viewModel.sortItems(by: .price)
            case .rating:
                self?.viewModel.sortItems(by: .rating)
            case .name:
                self?.viewModel.sortItems(by: .name)
            default:
                break
            }
        }
    }
    
    @objc
    private func didTapPaymentButton() {
        let paymentViewModel = PaymentViewModel()
        let paymentViewController = PaymentViewController(viewModel: paymentViewModel)
        let paymentNavigationController = UINavigationController(rootViewController: paymentViewController)
        paymentNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel.onItemsUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.updatePaymentViewLabels()
            self?.setLoadingState(isLoading: false)
            self?.setupNavigationBar()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .ypWhite
        
        view.addSubviews([tableView, paymentView, totalNFTCountInOrderLabel, totalCostLabel, paymentButton, activityIndicator])
        setupConstraints()
        setTableViewInsets()
        updatePaymentViewLabels()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setTableViewInsets() {
        tableView.contentInset.top = Constants.tableViewTopInset
        tableView.verticalScrollIndicatorInsets.top = Constants.tableViewTopInset
        tableView.setContentOffset(CGPoint(x: 0, y: -Constants.tableViewTopInset), animated: false)
    }
    
    private func updatePaymentViewLabels() {
        totalNFTCountInOrderLabel.text = "\(viewModel.itemsCount) NFT"
        totalCostLabel.text = "\(String(format: "%.2f", viewModel.getTotalCost())) ETH"
    }
    
    private func setLoadingState(isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        paymentView.isHidden = isLoading
        paymentButton.isHidden = isLoading
        totalCostLabel.isHidden = isLoading
        totalNFTCountInOrderLabel.isHidden = isLoading
        
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            tableViewConstraints() +
            paymentViewConstraints() +
            totalNFTCountLabelConstraints() +
            totalCostLabelConstraints() +
            paymentButtonConstraints()
        )
        activityIndicator.constraintCenters(to: view)
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        [tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor)
        ]
    }
    
    private func paymentViewConstraints() -> [NSLayoutConstraint] {
        [paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         paymentView.heightAnchor.constraint(equalToConstant: Constants.paymentViewHeight)
        ]
    }
    
    private func totalNFTCountLabelConstraints() -> [NSLayoutConstraint] {
        [totalNFTCountInOrderLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: Constants.totalNFTCountLabelTopInset),
         totalNFTCountInOrderLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: Constants.totalNFTCountLabelHorizontalInset),
         totalNFTCountInOrderLabel.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -Constants.totalNFTCountLabelHorizontalInset)
        ]
    }
    
    private func totalCostLabelConstraints() -> [NSLayoutConstraint] {
        [totalCostLabel.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: Constants.totalCostLabelBottomInset),
         totalCostLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: Constants.totalCostLabelLeadingInset)
        ]
    }
    
    private func paymentButtonConstraints() -> [NSLayoutConstraint] {
        [paymentButton.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: Constants.paymentButtonBottomInset),
         paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: Constants.paymentButtonTrailingInset),
         paymentButton.leadingAnchor.constraint(equalTo: totalCostLabel.trailingAnchor, constant: Constants.paymentButtonLeadingInset),
         paymentButton.heightAnchor.constraint(equalToConstant: Constants.paymentButtonHeight)
        ]
    }
}

// MARK: - Extensions

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        let orderCard = viewModel.getItem(at: indexPath.row)
        cell.setupCell(with: orderCard)
        return cell
    }
}

extension CartViewController: UITableViewDelegate {}

private extension CartViewController {
    struct Constants {
        static let tableViewRowHeight: CGFloat = 140
        static let paymentViewHeight: CGFloat = 76
        static let paymentButtonHeight: CGFloat = 44
        static let tableViewTopInset: CGFloat = 20
        static let totalNFTCountLabelTopInset: CGFloat = 16
        static let totalCostLabelBottomInset: CGFloat = -16
        static let paymentButtonBottomInset: CGFloat = -16
        static let paymentButtonLeadingInset: CGFloat = 24
        static let totalNFTCountLabelHorizontalInset: CGFloat = 16
        static let totalCostLabelLeadingInset: CGFloat = 16
        static let paymentButtonTrailingInset: CGFloat = -16
    }
}
