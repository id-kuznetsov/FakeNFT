import UIKit

final class MyNFTsViewController: UIViewController {
    
    // MARK: - Section
    
    private enum Section: Hashable {
        case main
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Nft>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Nft>
    
    // MARK: - Private Properties
    
    private let viewModel: MyNFTsViewModel
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshMyNfts), for: .valueChanged)
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self)
        tableView.delegate = self
        
        tableView.isHidden = true
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, nft in
            let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.defaultReuseIdentifier)
            guard let myNFTCell = cell as? MyNFTCell else {
                return UITableViewCell()
            }
            
            myNFTCell.delegate = self
            myNFTCell.setupCell(nft: nft)
            myNFTCell.isLiked = self?.viewModel.isLikedNft(at: indexPath) ?? false
            return myNFTCell
        }
    }()
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: .icSort,
            style: .done,
            target: self,
            action: #selector(sortButtonDidTap)
        )
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.MyNFTs.placeholder
        label.isHidden = true
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // MARK: - Init
    
    init(viewModel: MyNFTsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        title = L10n.MyNFTs.title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        startLoading()
        setupDataBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(tableView, placeholderLabel, activityIndicator)
        navigationItem.rightBarButtonItem = sortBarButtonItem
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupDataBindings() {
        viewModel.nfts.bind { [weak self] nfts in
            guard let self else { return }
            guard !viewModel.isLoading else { return }
            stopLoading()
            tableView.isHidden = nfts.isEmpty
            placeholderLabel.isHidden = !nfts.isEmpty
            
            applySnapshot(nfts: nfts)
        }
        
        viewModel.isRefreshing.bind { [weak self] isRefreshing in
            if !isRefreshing {
                self?.stopRefresh()
            }
        }
    }
    
    private func applySnapshot(nfts: [Nft]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(nfts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func stopRefresh() {
        refreshControl.endRefreshing()
    }
    
    private func startLoading() {
        tableView.isHidden = true
        placeholderLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @objc private func refreshMyNfts(_ sender: Any) {
        viewModel.refreshNfts()
    }
    
    @objc private func sortButtonDidTap() {
        AlertPresenter.presentSortAlert(on: self, sortOptions: [.price, .rating, .name]) { [weak self] option in
            self?.viewModel.sortNfts(by: option)
        }
    }
}

// MARK: - UITableViewDelegate

extension MyNFTsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
}

// MARK: - MyNFTCellDelegate

extension MyNFTsViewController: MyNFTCellDelegate {
    func didTapFavouriteButton(on cell: MyNFTCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.didTapFavouriteButtonOnCell(at: indexPath)
    }
}
