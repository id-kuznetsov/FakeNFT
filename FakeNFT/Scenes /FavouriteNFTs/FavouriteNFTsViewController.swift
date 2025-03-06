import UIKit

final class FavouriteNFTsViewController: UIViewController {
    
    // MARK: - Section
    
    private enum Section: Hashable {
        case main
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Nft>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Nft>
    
    // MARK: - Constants
    
    private enum Constants {
        static let itemsPerLine = 2
        static let itemHeight: CGFloat = 80.0
        static let interItemSpacing: CGFloat = 7.0
        static let lineSpacing: CGFloat = 20.0
        static let leadingInset: CGFloat = 6.0
        static let trailingInset: CGFloat = 6.0
    }
    
    // MARK: - Private Properties
    
    private let service: NftService
    private var favourites: [NftID] = []
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshFavouriteNfts), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = collectionViewLayout
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.register(FavouriteNftCell.self, forCellWithReuseIdentifier: FavouriteNftCell.defaultReuseIdentifier)
        
        collection.backgroundColor = .clear
        collection.refreshControl = refreshControl
        collection.allowsSelection = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let availableWidth = view.frame.width - Constants.leadingInset - Constants.trailingInset - CGFloat(Constants.itemsPerLine) * Constants.interItemSpacing
        layout.itemSize = CGSize(width: availableWidth / CGFloat(Constants.itemsPerLine), height: Constants.itemHeight)
        layout.minimumLineSpacing = Constants.lineSpacing
        layout.minimumInteritemSpacing = Constants.interItemSpacing
        layout.sectionInset = UIEdgeInsets(top: 20, left: Constants.leadingInset, bottom: 40, right: Constants.trailingInset)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, nft in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FavouriteNftCell.defaultReuseIdentifier,
                for: indexPath
            )
            guard let favouriteCell = cell as? FavouriteNftCell else {
                return cell
            }
            
            favouriteCell.delegate = self
            favouriteCell.isLiked = true
            favouriteCell.setupCell(nft: nft)
            return favouriteCell
        }
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет NFT"
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(service: NftService, favourites: [NftID]) {
        self.service = service
        self.favourites = favourites
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
        
        service.loadNfts(ids: favourites) { [weak self] result in
            switch result {
            case .success(let nfts):
                self?.applySnapshot(nfts: nfts)
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        view.addSubviews(collectionView, placeholderLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupDataBindings() {
        
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
    
    @objc private func refreshFavouriteNfts(_ sender: Any) {
        
    }
}

extension FavouriteNFTsViewController: FavouriteNftCellDelegate {
    func didTapFavouriteButton(on cell: FavouriteNftCell) {
        
    }
}

