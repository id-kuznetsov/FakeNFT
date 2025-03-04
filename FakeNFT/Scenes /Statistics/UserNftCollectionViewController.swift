//
//  UserNftCollectionViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 03.03.2025.
//

import UIKit

final class UserNftCollectionViewController: UIViewController {
    
    // MARK: - Private properties
    private let viewModel: UserNftCollectionViewModelProtocol
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "PlaceholderCell"
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initializer
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
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        title = "Коллекция NFT"
        
        view.addSubview(collectionView)
        
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
        6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PlaceholderCell",
            for: indexPath
        )
        
        cell.contentView.backgroundColor = .ypLightGrey
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension UserNftCollectionViewController: UICollectionViewDelegate {
    
}

