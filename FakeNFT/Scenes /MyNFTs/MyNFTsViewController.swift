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
    
    let nftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTCell.self)
        tableView.delegate = self
        
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
            
            myNFTCell.setupCell(nft: nft, isLiked: false)
            return myNFTCell
        }
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
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
        title = "Мои NFT"
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupDataBindings() {
        
    }
    
    private func applySnapshot(nfts: [Nft]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(nfts)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate

extension MyNFTsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
}

extension MyNFTsViewController: MyNFTCellDelegate {
    func didTapFavouriteButton(on cell: MyNFTCell) {
        
    }
}
