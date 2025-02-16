//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 13.02.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Dependencies
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - UI Elements
    private lazy var customNavBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        return navBar
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic.filter"), for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(customNavBar)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        configureCustomNavBar()
    }
    
    private func configureCustomNavBar() {
        let navItem = UINavigationItem()
        let filterBarButton = UIBarButtonItem(customView: filterButton)
        navItem.rightBarButtonItem = filterBarButton
        
        customNavBar.setItems([navItem], animated: false)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 19.5
        navItem.rightBarButtonItems = [spacer, filterBarButton]
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        // TO DO: Add a call to AlertPresenter with sorting options by name and by rating.
    }
}
