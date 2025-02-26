//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Aleksei Frolov on 25.02.2025.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .ypBlack
        return progressView
    }()
    
    private lazy var customNavBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        return navBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.chevronLeft, for: .normal)
        button.tintColor = .ypBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        configureCustomNavBar()
    }
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = webView.estimatedProgress >= 1.0
        }
    }
    
    private func setupView() {
        view.backgroundColor = .ypWhite
        
        [webView, progressView, customNavBar].forEach { element in
            view.addSubview(element)
            element.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func configureCustomNavBar() {
        let navItem = UINavigationItem()
        let backBarButton = UIBarButtonItem(customView: backButton)
        navItem.leftBarButtonItem = backBarButton
        customNavBar.setItems([navItem], animated: false)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        progressView.isHidden = true
    }
}
