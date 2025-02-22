//
//  CollectionsViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 18.02.2025.
//

import UIKit
import Combine

final class CollectionsViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CollectionsViewModelProtocol
    private var subscribers = Set<AnyCancellable>()

    // MARK: - UI
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .ypWhite
        view.register(CollectionsTableViewCell.self)
        view.separatorStyle = .none
        view.rowHeight = 180
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
        view.backgroundColor = .ypWhite

        view.addSubview(tableView)

        setupNavigationBar()
        setupConstraints()
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

    private func presentCollectionViewController(for collection: CollectionUI) {
        let viewModel = CollectionViewModel(
            nftsService: viewModel.nftsService,
            collection: collection
        )
        let viewController = CollectionViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Actions
    @objc
    private func presentFilterActionSheet() {
        let actionSheet = UIAlertController(title: "Фильтры", message: "Выберите фильтр", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(actionSheet, animated: true)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        cell.configure(with: collectionUI)

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
