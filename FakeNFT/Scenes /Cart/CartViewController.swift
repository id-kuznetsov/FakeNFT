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
    // MARK: - Private Methods
    
    private func setupUI() {
        setupNavigationBar()
        view.backgroundColor = .ypWhite
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
    // MARK: Constraints
   
}

// MARK: - Extensions
