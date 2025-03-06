//
//  UserNftCollectionViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

final class UserNftCollectionViewController: UIViewController {
    
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
        collectionView.register(
            UserNftCollectionCell.self,
            forCellWithReuseIdentifier: UserNftCollectionCell.identifier
        )
    }
    
    private func setupBindings() {
        viewModel.onNftCollectionUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            }
        }
    }
    
    private func showLoadingIndicator() {
        UIBlockingProgressIndicator.show()
    }
    
    private func hideLoadingIndicator() {
        UIBlockingProgressIndicator.dismiss()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Коллекция NFT"
        
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
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserNftCollectionCell.identifier,
            for: indexPath
        ) as? UserNftCollectionCell else {
            return UICollectionViewCell()
        }
        
        let nft = viewModel.nftCollection[indexPath.row]
        let isLiked = viewModel.likedNfts.contains(nft.id)
        
        cell.configure(with: nft, isLiked: isLiked)
        cell.onLikeTapped = { [weak self] nftId in
            self?.viewModel.toggleLike(for: nftId)
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
            width: (collectionView.bounds.width - 2 * 16 - 2 * 10) / 3,
            height: 192
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
}
