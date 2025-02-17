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
    private let viewModel = StatisticsViewModel()
    
    // MARK: - UI Elements
    private lazy var customNavBar: UINavigationBar = {
        let navBar = UINavigationBar()
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
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
        
        [customNavBar, tableView].forEach { element in
            view.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

extension StatisticsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.users.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.identifier, 
            for: indexPath
        ) as? StatisticsCell else {
            return UITableViewCell()
        }
        
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user, index: indexPath.row)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        88
    }
}
