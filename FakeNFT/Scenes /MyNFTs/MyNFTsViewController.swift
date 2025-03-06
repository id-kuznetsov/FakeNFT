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
    
    // MARK: - Init
    
    init(viewModel: MyNFTsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        title = "Мои NFT"
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
        setupDataBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDataBindings() {
        viewModel.nfts.bind { [weak self] nfts in
            self?.applySnapshot(nfts: nfts)
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
    
    // MARK: - Actions
    
    @objc private func refreshMyNfts(_ sender: Any) {
        viewModel.refreshNfts()
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
