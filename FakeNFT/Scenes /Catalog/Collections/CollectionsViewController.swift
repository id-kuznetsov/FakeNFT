//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import UIKit
import Combine

final class CollectionsViewController: UIViewController, FilterView, ErrorView, LoadingView {
    // MARK: - Properties
    private let viewModel: CollectionsViewModelProtocol
    private var subscribers = Set<AnyCancellable>()

    // MARK: - UI
    lazy var activityIndicator = UIActivityIndicatorView()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .ypWhite
        view.register(CollectionsTableViewCell.self)
        view.rowHeight = LayoutConstants.CollectionsScreen.rowHeight
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(viewModel: CollectionsViewModelProtocol) {
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

        setupNavigationBar()
        setupLayout()
        viewModel.loadCollections()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.collectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink( receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        subscribers.forEach { $0.cancel() }
        subscribers.removeAll()
    }

    private func stateDidChanged() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink( receiveValue: { [weak self] state in
                guard let self else { return }

                switch state {
                case .initial:
                    assertionFailure("can't move to initial state")
                case .loading:
                    self.showLoading()
                    self.viewModel.loadCollections()
                case .success:
                    self.hideLoading()
                    self.tableView.reloadData()
                case .failed(let error):
                    self.hideLoading()
                    self.showError(error)
                }
            })
            .store(in: &subscribers)
    }

    // MARK: - Setup NavBar
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(
            image: .icSort,
            style: .plain,
            target: self,
            action: #selector(presentFilterActionSheet)
        )
        filterButton.tintColor = .ypBlack
        navigationItem.rightBarButtonItem = filterButton
    }

    // MARK: - Navigation
    private func presentCollectionViewController(
        for collection: CollectionUI
    ) {
        let viewModel = CollectionViewModel(
            imageLoaderService: viewModel.imageLoaderService,
            nftsService: viewModel.nftsService,
            collection: collection,
            userService: viewModel.userService
        )
        let viewController = CollectionViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Alert
    func showError(_ error: Error) {
        showError(
            error: error,
            buttons: [
                .cancel,
                .reload(
                    action: { [weak self] in
                        guard let self else { return }

                        self.viewModel.viewDidLoad()
                    }
                )
            ]
        )
    }

    // MARK: - Actions
    @objc
    private func presentFilterActionSheet() {
        showFilters(
            style: .actionSheet,
            buttons: [
                .sortByName(action: viewModel.sortByCollectionName),
                .sortByNftCount(action: viewModel.sortByNftCount),
                .close
            ]
        )
    }

    // MARK: - Constraints
    private func setupLayout() {
        view.backgroundColor = .ypWhite

        tableView.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: tableView)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: LayoutConstants.CollectionsScreen.tableMargin
            ),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension CollectionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.collections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollectionsTableViewCell = tableView.dequeueReusableCell()
        let collectionUI = viewModel.getCollection(at: indexPath)

        cell.selectionStyle = .none
        cell.configure(
            with: collectionUI,
            imageLoaderService: viewModel.imageLoaderService
        )

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionUI = viewModel.getCollection(at: indexPath)
        presentCollectionViewController(for: collectionUI)
    }
}
