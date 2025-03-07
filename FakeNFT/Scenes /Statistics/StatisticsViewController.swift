//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 13.02.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private properties
    private var viewModel: StatisticsViewModelProtocol
    
    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "ic.sort"),
            style: .plain,
            target: self,
            action: #selector(filterButtonTapped)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        
        setupUI()
        setupBindings()
        viewModel.loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -StatisticsConstants.StatisticsVc.TableViewParams.sideMarginFromEdges
            ),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.scrollIndicatorInsets = UIEdgeInsets(
            top: StatisticsConstants.StatisticsVc.TableViewParams.containerViewtopInset,
            left: StatisticsConstants.StatisticsVc.TableViewParams.containerViewleftInset,
            bottom: StatisticsConstants.StatisticsVc.TableViewParams.containerViewbottomInset,
            right: -StatisticsConstants.StatisticsVc.TableViewParams.containerViewRightInset
        )
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = filterButton
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
        viewModel.onErrorOccurred = { [weak self] _ in
            DispatchQueue.main.async {
                self?.showNetworkErrorAlert()
            }
        }
    }
    
    private func showNetworkErrorAlert() {
        AlertPresenter.presentNetworkErrorAlert(on: self) { [weak self] in
            self?.viewModel.fetchNextPage()
        }
    }
    
    private func showLoadingIndicator() {
        UIBlockingProgressIndicator.show()
    }
    
    private func hideLoadingIndicator() {
        UIBlockingProgressIndicator.dismiss()
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
        
        let cell: StatisticsCell = tableView.dequeueReusableCell()
        
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
        StatisticsConstants.StatisticsVc.TableViewParams.heightForRow
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = viewModel.users[indexPath.row]
        let userCardViewModel = viewModel.createUserCardViewModel(for: user.id)
        let userCardVC = UserCardViewController(viewModel: userCardViewModel)
        
        navigationController?.pushViewController(userCardVC, animated: true)
        tabBarController?.tabBar.isHidden = true
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
