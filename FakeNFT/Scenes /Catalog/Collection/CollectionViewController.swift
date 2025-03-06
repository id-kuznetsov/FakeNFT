//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 20.02.2025.
//

import UIKit
import Combine

final class CollectionViewController: UIViewController, ErrorView, RatingView {
    // MARK: - Properties
    private var subscribers = Set<AnyCancellable>()
    private let viewModel: CollectionViewModelProtocol

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
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
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

        view.backgroundColor = .ypWhite
        view.addSubview(collectionView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.nftsPublisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.reloadSectionCells(collectionView: self.collectionView, section: 0)
                }
            )
            .store(in: &subscribers)
    }

    private func reloadSectionCells(collectionView: UICollectionView, section: Int) {
        let itemCount = collectionView.numberOfItems(inSection: section)
        guard itemCount > 0 else { return }

        let indexPaths = (0..<itemCount).map { IndexPath(item: $0, section: section) }

        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: indexPaths)
        }, completion: nil)
    }

    // MARK: - Navigation
    private func presentWebViewController(with authorName: String) {
        let viewModel = WebViewViewModel(
            authorName: authorName
        )
        let viewController = WebViewController(viewModel: viewModel)
        viewController.delegate = self

        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LayoutConstants.CollectionScreen.numberOfSections
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: NftCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let nftUI = viewModel.nfts[indexPath.item]

        cell.backgroundColor = .clear
        cell.delegate = self
        cell.configure(
            nftUI: nftUI,
            imageLoaderService: viewModel.imageLoaderService
        )
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: CollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                indexPath: indexPath
            )
            header.configure(
                with: viewModel.collectionUI,
                imageLoaderService: viewModel.imageLoaderService
            )
            header.delegate = self
            return header
        }
        return UICollectionReusableView()
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
        let nftUI = viewModel.nfts[indexPath.item]
        print("nft cell tapped - \(nftUI.name)")
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
