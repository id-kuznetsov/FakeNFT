//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 18.02.2025.
//

import UIKit

final class PaymentViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var viewModel: PaymentViewModelProtocol
    
    // MARK: - Initialisers
    
    init(viewModel: PaymentViewModelProtocol) {
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
        view.backgroundColor = .ypBlueUniversal
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    
}
