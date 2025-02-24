//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 13.02.2025.
//

import UIKit
import ProgressHUD

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private properties
    private var viewModel: StatisticsViewModelProtocol
    
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
    
    // MARK: - Initializers
    init(viewModel: StatisticsViewModelProtocol) {
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
        setupBindings()
        viewModel.loadInitialData()
    }
    
    // MARK: - Private methods
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
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3)
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
    
    private func setupBindings() {
        viewModel.onUsersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        }
    }
    
    private func showLoadingIndicator() {
        self.view.isUserInteractionEnabled = false
        ProgressHUD.colorAnimation = .ypBlack
        ProgressHUD.show()
    }
    
    private func hideLoadingIndicator() {
        self.view.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        AlertPresenter.presentSortAlert(
            on: self,
            sortOptions: [.name, .rating],
            preferredStyle: .actionSheet
        ) {
            [weak self] selectedOption in
            guard let self = self else { return }
            
            self.viewModel.sortUsers(by: selectedOption)
        }
    }
}

// MARK: UITableViewDataSource
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
        guard indexPath.row < viewModel.users.count else {
            return UITableViewCell()
        }
        
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

// MARK: UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        88
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = viewModel.users[indexPath.row]
        let userCardVC = UserCardViewController(user: user)
        
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(userCardVC, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
            let lastIndex = viewModel.users.count - 1
            
            if indexPath.row == lastIndex {
                viewModel.fetchNextPage()
            }
        }
}
