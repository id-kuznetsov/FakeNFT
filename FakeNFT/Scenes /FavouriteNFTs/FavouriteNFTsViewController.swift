import UIKit

final class FavouriteNFTsViewController: UIViewController, ErrorView {
    
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
        static let leadingInset: CGFloat = 16.0
        static let trailingInset: CGFloat = 16.0
    }
    
    // MARK: - Private Properties
    
    private let viewModel: FavouritesNFTsViewModel
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshFavouriteNfts), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = collectionViewLayout
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collection.register(FavouriteNftCell.self)
        
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
            let favouriteCell = collectionView.dequeueReusableCell(indexPath: indexPath) as FavouriteNftCell
            favouriteCell.delegate = self
            favouriteCell.isLiked = true
            favouriteCell.setupCell(nft: nft)
            return favouriteCell
        }
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.FavouritesNFTs.placeholder
        label.font = .bodyBold
        label.textColor = .ypBlack
        label.isHidden = true
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
    
    init(viewModel: FavouritesNFTsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        title = L10n.FavouritesNFTs.title
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
        view.addSubviews(collectionView, placeholderLabel, activityIndicator)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            collectionView.isHidden = nfts.isEmpty
            placeholderLabel.isHidden = !nfts.isEmpty
            
            applySnapshot(nfts: nfts)
        }
        
        viewModel.isRefreshing.bind { [weak self] isRefreshing in
            if !isRefreshing {
                self?.stopRefresh()
            }
        }
        
        viewModel.errorModel.bind { [weak self] errorModel in
            guard let errorModel else { return }
            self?.showError(errorModel)
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
        collectionView.isHidden = true
        placeholderLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Actions
    
    @objc private func refreshFavouriteNfts(_ sender: Any) {
        viewModel.refreshNfts()
    }
}

extension FavouriteNFTsViewController: FavouriteNftCellDelegate {
    func didTapFavouriteButton(on cell: FavouriteNftCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.didTapFavouriteButtonOnCell(at: indexPath)
    }
}

