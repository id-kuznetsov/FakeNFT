//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit
import Combine

final class CollectionViewController: UIViewController, ErrorView, RatingView, LoadingView {
    // MARK: - Properties
    private var subscribers = Set<AnyCancellable>()
    private let viewModel: CollectionViewModelProtocol

    // MARK: - DataSource
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NftUI> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, NftUI>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, nftUI in
                guard let self = self else { return UICollectionViewCell() }

                let cell: NftCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.backgroundColor = .clear
                cell.delegate = self
                cell.configure(
                    model: nftUI,
                    imageLoaderService: viewModel.imageLoaderService
                )
                return cell
            }
        )

        dataSource
            .supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
                guard let self = self else { return nil }

                if kind == UICollectionView.elementKindSectionHeader {
                    let header: CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        indexPath: indexPath
                    )
                    header.configure(
                        with: self.viewModel.collectionUI,
                        imageLoaderService: self.viewModel.imageLoaderService
                    )
                    header.delegate = self
                    return header
                }
                return nil
            }

        return dataSource
    }()

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(NftCollectionViewCell.self)
        view.register(
            CollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        view.contentInsetAdjustmentBehavior = .never
        view.alwaysBounceVertical = true
        view.allowsMultipleSelection = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var refreshControlView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return view
    }()

    // MARK: - Init
    init(
        viewModel: CollectionViewModelProtocol
    ) {
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

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.nfts
            .receive(on: DispatchQueue.main)
            .sink( receiveValue: { [weak self] nfts in
                self?.applySnapshot(nfts)
            })
            .store(in: &subscribers)

        viewModel.state
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink( receiveValue: { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .loading:
                    self.collectionView.bounces = false
                    self.collectionView.isUserInteractionEnabled = false
                    self.showLoading()
                case .success:
                    self.collectionView.bounces = true
                    self.collectionView.isUserInteractionEnabled = true
                    self.hideLoading()
                case .failed(let error):
                    self.hideLoading()
                    self.showError(error)
                    self.collectionView.bounces = true
                    self.collectionView.isUserInteractionEnabled = true
                default:
                    break
                }
            })
            .store(in: &subscribers)
    }

    private func applySnapshot(_ nfts: [NftUI], animating: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(nfts, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animating)
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

//    private func reloadSectionCells(collectionView: UICollectionView, section: Int) {
//        let itemCount = collectionView.numberOfItems(inSection: section)
//        guard itemCount > 0 else { return }
//
//        let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: section) }
//
//        collectionView.performBatchUpdates({
//            collectionView.reloadItems(at: indexPaths)
//        }, completion: nil)
//    }

    // MARK: - Navigation
    private func presentWebViewController(with authorName: String) {
        let viewModel = WebViewViewModel(
            authorName: authorName
        )
        let viewController = WebViewController(viewModel: viewModel)
        viewController.delegate = self

        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Actions
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
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableSpace = collectionView.frame.width - LayoutConstants.CollectionScreen.CollectionParams.paddingWidth
        let cellWidth = availableSpace / LayoutConstants.CollectionScreen.CollectionParams.cellCount
        return CGSize(
            width: cellWidth,
            height: LayoutConstants.CollectionScreen.CollectionParams.cellHeight
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let insets = UIEdgeInsets(
            top: LayoutConstants.CollectionScreen.CollectionParams.topInset,
            left: LayoutConstants.CollectionScreen.CollectionParams.leftInset,
            bottom: LayoutConstants.CollectionScreen.CollectionParams.bottomInset,
            right: LayoutConstants.CollectionScreen.CollectionParams.rightInset
        )

        return insets
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        return LayoutConstants.CollectionScreen.CollectionParams.cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return LayoutConstants.CollectionScreen.CollectionParams.lineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let headerView = CollectionHeaderView(frame: .zero)
        headerView.configure(
            with: viewModel.collectionUI,
            imageLoaderService: viewModel.imageLoaderService
        )

        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: collectionView.frame.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        print("nft cell tapped")
    }
}

// MARK: - CollectionHeaderViewDelegate
extension CollectionViewController: CollectionHeaderViewDelegate {
    func collectionHeaderViewDidTapAuthor(_ headerView: CollectionHeaderView) {
        guard
            let authorName = headerView.authorButton.title(for: .normal)
        else {
            let error: Error = NSError(
                domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Author name not found"]
            )
            showError(error: error, buttons: [.close])
            return
        }

        presentWebViewController(with: authorName)
    }
}

// MARK: - NftCollectionViewCellDelegate
extension CollectionViewController: NftCollectionViewCellDelegate {
    func nftCollectionViewCellDidTapRating(_ cell: NftCollectionViewCell) {
        guard let image = cell.nftImageView.image else { return }

        showChangeRating(image)
    }

    func nftCollectionViewCellDidTapFavorite(_ cell: NftCollectionViewCell) {
        if cell.favoriteButton.tintColor == .ypWhiteUniversal {
            cell.favoriteButton.tintColor = .ypRedUniversal
        } else if cell.favoriteButton.tintColor == .ypRedUniversal {
            cell.favoriteButton.tintColor = .ypWhiteUniversal
        }
    }

    func nftCollectionViewCellDidTapCart(_ cell: NftCollectionViewCell) {
        if cell.cartButton.image(for: .normal) == .icCart {
            cell.cartButton.setImage(.icCartDelete, for: .normal)
        } else if cell.cartButton.image(for: .normal) == .icCartDelete {
            cell.cartButton.setImage(.icCart, for: .normal)
        }
    }
}

// MARK: - WebViewControllerDelegate
extension CollectionViewController: WebViewControllerDelegate {
    func webViewControllerDidBack(_ controller: WebViewController) {
        navigationController?.popViewController(animated: true)
    }
}
