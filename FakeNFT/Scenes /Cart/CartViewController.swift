//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetesov on 13.02.2025.
//

import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let viewModel: CartViewModelProtocol
    private let servicesAssembly: ServicesAssembly
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhite
        tableView.rowHeight = 140 // TODO: вынести в константы
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
        label.text = "3 NFT" // TODO: получить из viewModel
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "5,34 ETH" // TODO: получить из viewModel
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
    
    // MARK: - Initialisers
    
    init(viewModel: CartViewModelProtocol,servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
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
    
    // MARK: - Actions
    
    @objc
    private func didTapFilterButton() {
        print("didTapFilterButton")
        // TODO: handle filter button tap
    }
    
    @objc
    private func didTapPaymentButton() {
        // TODO: handle payment button tap
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .ypWhite
        
        view.addSubviews([tableView, paymentView, totalNFTCountInOrderLabel, totalCostLabel, paymentButton])
        setupConstraints()
        setTableViewInsets()
    }
    
    private func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(
            image: .icFilter,
            style: .done,
            target: self,
            action: #selector(didTapFilterButton)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
    }
    
    private func setTableViewInsets() {
        tableView.contentInset.top = 20
        tableView.verticalScrollIndicatorInsets.top = 20
        tableView.setContentOffset(CGPoint(x: 0, y: -20), animated: false)
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
         paymentView.heightAnchor.constraint(equalToConstant: 76)
        ]
    }
    
    private func totalNFTCountLabelConstraints() -> [NSLayoutConstraint] {
        [totalNFTCountInOrderLabel.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
         totalNFTCountInOrderLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
         totalNFTCountInOrderLabel.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16)
        ]
    }
    
    private func totalCostLabelConstraints() -> [NSLayoutConstraint] {
        [totalCostLabel.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
         totalCostLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16)
        ]
    }
    
    private func paymentButtonConstraints() -> [NSLayoutConstraint] {
        [paymentButton.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
         paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
         paymentButton.leadingAnchor.constraint(equalTo: totalCostLabel.trailingAnchor, constant: 24),
         paymentButton.heightAnchor.constraint(equalToConstant: 44)
        ]
    }
    
}

// MARK: - Extensions

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartTableViewCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
}
