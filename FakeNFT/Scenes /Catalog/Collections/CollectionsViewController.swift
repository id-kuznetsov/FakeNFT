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
    private var dataSource: UITableViewDiffableDataSource<Int, CollectionUI>!
    private var subscribers = Set<AnyCancellable>()

    // MARK: - UI
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .ypWhite
        view.register(CollectionsTableViewCell.self)
        view.rowHeight = LayoutConstants.CollectionsScreen.rowHeight
        view.separatorStyle = .none
        view.delegate = self
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

        setupDataSource()

        bindViewModel()
        viewModel.loadData()
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.collections
            .receive(on: DispatchQueue.main)
            .sink( receiveValue: { [weak self] collections in
                self?.applySnapshot(collections)
            })
            .store(in: &subscribers)

        viewModel.state
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink( receiveValue: { [weak self] state in
                guard let self else { return }

                switch state {
                case .loading:
                    self.showLoading()
                    print("show loading")
                case .success:
                    self.hideLoading()
                    print("success hide loading")
                case .failed(let error):
                    self.hideLoading()
                    print("failed hide loading")
                    self.showError(error)
                    print("show error")
                default:
                    break
                }
            })
            .store(in: &subscribers)
    }

    private func applySnapshot(_ collections: [CollectionUI], animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(collections, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // MARK: - DataSource
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, CollectionUI>(
            tableView: tableView
        ) { [weak self] tableView, indexPath, collection in
            guard let self = self else { return UITableViewCell() }

            let cell: CollectionsTableViewCell = self.tableView.dequeueReusableCell()
            cell.selectionStyle = .none
            cell.configure(
                with: collection,
                imageLoaderService: self.viewModel.imageLoaderService
            )
            return cell
        }
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

                        self.viewModel.loadData()
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

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: LayoutConstants.CollectionsScreen.tableMargin
            ),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension CollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionUI = viewModel.getCollection(at: indexPath)
        presentCollectionViewController(for: collectionUI)
    }
}
