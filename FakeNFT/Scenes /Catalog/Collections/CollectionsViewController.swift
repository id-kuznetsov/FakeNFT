//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import UIKit
import Combine

final class CollectionsViewController: UIViewController, FilterView, CatalogErrorView, CatalogLoadingView {
    // MARK: - Properties
    private let viewModel: CollectionsViewModelProtocol
    private var subscribers = Set<AnyCancellable>()
    private var pendingCollections: [Collection]?

    // MARK: - DataSource
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Collection> = {
        let dataSource = UITableViewDiffableDataSource<Int, Collection>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, _, collection in
                guard let self = self else { return UITableViewCell() }
                let cell: CollectionsTableViewCell = tableView.dequeueReusableCell()
                cell.selectionStyle = .none
                cell.configure(
                    with: collection,
                    imageLoaderService: self.viewModel.imageLoaderService
                )
                return cell
            }
        )
        return dataSource
    }()

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .ypWhite
        view.register(CollectionsTableViewCell.self)
        view.separatorStyle = .none
        view.refreshControl = refreshControlView
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var filterButton: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.style = .plain
        view.image = .icSort
        view.tintColor = .ypBlack
        view.target = self
        view.action = #selector(presentFilterActionSheet)
        return view
    }()

    private lazy var refreshControlView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
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

        setupLayout()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.loadData(skipCache: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        applyPendingSnapshot()
    }

    // MARK: - Binding
    private func bindViewModel() {
        bindCollections()
        bindState()
        bindTableViewContentOffset()
    }

    private func bindCollections() {
        viewModel.collections
            .receive(on: DispatchQueue.main)
            .sink( receiveValue: { [weak self] collections in
                guard let self = self else { return }

                self.pendingCollections = collections
                if self.tableView.window != nil {
                    self.applyPendingSnapshot()
                }
            })
            .store(in: &subscribers)
    }

    private func bindState() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &subscribers)
    }

    private func bindTableViewContentOffset() {
        tableView.publisher(for: \.contentOffset, options: [.new])
            .sink { [weak self] contentOffset in
                self?.handleContentOffset(contentOffset)
            }
            .store(in: &subscribers)
    }

    private func handleState(_ state: CollectionsState) {
        switch state {
        case .loading:
            tableView.bounces = false
            tableView.isUserInteractionEnabled = false
            filterButton.isEnabled = false
            showLoading()
        case .success:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }

                self.tableView.bounces = true
                self.tableView.isUserInteractionEnabled = true
                self.filterButton.isEnabled = true
                self.hideLoading()
            }
        case .failed(let error):
            hideLoading()
            showError(error)
            tableView.bounces = true
            tableView.isUserInteractionEnabled = true
            filterButton.isEnabled = true
        default:
            break
        }
    }

    private func handleContentOffset(_ contentOffset: CGPoint) {
        let offsetY = contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = tableView.frame.size.height
        let threshold: CGFloat = 10

        guard contentHeight > frameHeight else { return }

        if offsetY > contentHeight - frameHeight - threshold {
            viewModel.loadNextPage(reset: false, skipCache: false)
        }
    }

    private func applyPendingSnapshot(animating: Bool = true) {
        guard let collections = pendingCollections else { return }
        pendingCollections = nil
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(collections, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    // MARK: - Navigation
    private func presentCollectionViewController(
        for collection: Collection
    ) {
        let collectionServiceAssembler = CollectionServiceAssembly(
            imageLoaderService: viewModel.imageLoaderService,
            collectionNftService: viewModel.collectionNftService,
            orderService: viewModel.orderService,
            profileService: viewModel.profileService,
            collectionUI: collection
        )

        let collectionViewController = collectionServiceAssembler.build()
        collectionViewController.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(collectionViewController, animated: true)
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

                        self.viewModel.loadData(skipCache: false)
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
                .sortByName(action: { [weak self] in
                    self?.viewModel.sortCollections(by: .name)
                }),
                .sortByNftCount(action: { [weak self] in
                    self?.viewModel.sortCollections(by: .nfts)
                }),
                .close
            ]
        )
    }

    @objc
    private func didPullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }

            self.refreshControlView.endRefreshing()
            self.viewModel.loadData(skipCache: true)
        }
    }

    // MARK: - Constraints
    private func setupLayout() {
        view.backgroundColor = .ypWhite
        navigationItem.rightBarButtonItem = filterButton
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

// MARK: - UITableViewDelegate
extension CollectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let collection = try viewModel.getCollection(at: indexPath)
            presentCollectionViewController(for: collection)
        } catch {
            showError(error)
        }
    }
}
