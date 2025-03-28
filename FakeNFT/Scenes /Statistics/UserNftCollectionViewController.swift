//
//  UserNftCollectionViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

final class UserNftCollectionViewController: UIViewController, ErrorView {

    // MARK: - Private properties
    private var viewModel: UserNftCollectionViewModelProtocol

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    // MARK: - Initializers
    init(viewModel: UserNftCollectionViewModelProtocol) {
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

        setupUI()
        setupBindings()
        viewModel.loadNftCollection()
    }

    // MARK: - Private methods
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserNftCollectionCell.self)
        collectionView.contentInset = UIEdgeInsets(
            top: StatisticsConstants.UserNftVc.MainScreen.topEdgeInset,
            left: StatisticsConstants.UserNftVc.MainScreen.leftEdgeInset,
            bottom: StatisticsConstants.UserNftVc.MainScreen.bottomEdgeInset,
            right: StatisticsConstants.UserNftVc.MainScreen.rightEdgeInset
        )
    }

    private func setupBindings() {
        viewModel.onNftCollectionUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.collectionView.reloadData()
            }
        }

        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        }

        viewModel.onErrorOccurred = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let errorModel = ErrorModel(
                    message: errorMessage,
                    actionText: L10n.Error.repeat,
                    action: { self?.viewModel.loadNftCollection() }
                )
                self?.showError(errorModel)
            }
        }

        viewModel.onNoNftAvailable = { [weak self] in
            DispatchQueue.main.async {
                self?.showNoNftAlert()
            }
        }
    }

    private func showLoadingIndicator() {
        UIBlockingProgressIndicator.show()
    }

    private func hideLoadingIndicator() {
        UIBlockingProgressIndicator.dismiss()
    }

    private func showNoNftAlert() {
        AlertPresenter.presentAlertWithOneSelection(
            on: self,
            title: L10n.User.emptyCollection,
            message: L10n.User.noNft,
            actionTitle: L10n.Button.ok
        ) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func setupUI() {
        view.backgroundColor = .ypWhite
        title = L10n.User.nftCollection

        view.addSubview(collectionView)
        setupCollectionView()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension UserNftCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.nftCollection.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: UserNftCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        let nft = viewModel.nftCollection[indexPath.row]
        let isLiked = viewModel.likedNfts.contains(nft.id)
        let isInCart = viewModel.orderedNfts.contains(nft.id)

        cell.configure(with: nft, isLiked: isLiked, isInCart: isInCart)
        cell.onLikeTapped = { [weak self] nftId in
            self?.viewModel.toggleLike(for: nftId)
        }
        cell.onCartTapped = { [weak self] nftId in
            self?.viewModel.toggleCart(for: nftId)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserNftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: (
                collectionView.bounds.width - StatisticsConstants.Common.Margin.xxSmall
                * StatisticsConstants.UserNftVc.MainScreen.sideCollectionMargin
                - StatisticsConstants.Common.Margin.xxSmall
                *  StatisticsConstants.UserNftVc.MainScreen.horizontalCellsSpacing
            ) / StatisticsConstants.UserNftVc.MainScreen.cellsInRow,
            height: StatisticsConstants.UserNftVc.MainScreen.cellHeight
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: StatisticsConstants.UserNftVc.MainScreen.verticalCollectionSpacing,
            left: StatisticsConstants.UserNftVc.MainScreen.sideCollectionMargin,
            bottom: StatisticsConstants.UserNftVc.MainScreen.verticalCollectionSpacing,
            right: StatisticsConstants.UserNftVc.MainScreen.sideCollectionMargin)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        StatisticsConstants.UserNftVc.MainScreen.verticalCellsSpacing
    }
}
