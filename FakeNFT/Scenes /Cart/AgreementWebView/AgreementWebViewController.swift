//
//  AgreementWebViewController.swift
//  FakeNFT
//
//  Created by Ilya Kuznetsov on 21.02.2025.
//

import UIKit
import WebKit

final class AgreementWebViewController: UIViewController {
    // MARK: - Constants
    
    private enum WebViewConstants {
        static let urlString = "https://yandex.ru/legal/practicum_termsofuse/"
    }
    
    // MARK: - Private properties
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = .ypBlack
        return progressView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebViewInterface()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    // MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setWebViewInterface() {
        view.backgroundColor = .ypWhite
        
        view.addSubviews([webView, progressView])
        
        NSLayoutConstraint.activate(
            progressViewConstraints() +
            webViewConstraints()
        )
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhite
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronLeft,
            style: .done,
            target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
    private func loadWebView() {
        guard let url = URL(string: WebViewConstants.urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // MARK: - Constraints
    
    private func progressViewConstraints() -> [NSLayoutConstraint] {
        [progressView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
         progressView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor),
         progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
    }
    
    private func webViewConstraints() -> [NSLayoutConstraint] {
        [webView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
         webView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
         webView.topAnchor.constraint(equalTo: view.topAnchor),
         webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}

