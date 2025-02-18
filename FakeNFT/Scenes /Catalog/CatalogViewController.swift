//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 13.02.2025.
//

import UIKit

final class CatalogViewController: UIViewController {
    private let viewModel: CatalogViewModelProtocol

    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
