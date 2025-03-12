//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate: AnyObject {
    func webViewControllerDidBack(_ controller: WebViewController)
}

final class WebViewController: UIViewController, CatalogErrorView {
    // MARK: - Properties
    weak var delegate: WebViewControllerDelegate?
    private let viewModel: WebViewViewModel
    private let request: URLRequest
    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - UI
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progress = 0.5
        view.progressTintColor = .ypBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel
        self.request = viewModel.getRequest()

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayouts()
        addObserver()
        setupPullToRefresh()
        checkForBug()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        webView.load(request)
        updateProgress()
    }

    private func checkForBug() {
        if request.url?.absoluteString == "https://nikolaidev.ru" {
            showError(
                error: WebViewError.apiBug,
                buttons: [
                    .close,
                    .back(action: { [weak self] in
                        guard let self = self else { return }

                        self.delegate?.webViewControllerDidBack(self)
                    })
                ]
            )
        }
    }

    private func reloadWebView() {
        webView.load(request)
        webView.reload()
        webView.scrollView.refreshControl?.endRefreshing()
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }

    private func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
    }

    // MARK: - Observers
    private func addObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }

                 self.updateProgress()
             }
        )
    }

    // MARK: - Error View
    private func showWKWebViewError(_ error: Error) {
        showError(
            error: error,
            buttons: [
                .back(action: { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.webViewControllerDidBack(self)
                }),
                .reload(action: { [weak self] in
                    self?.reloadWebView()
                })
            ]
        )
    }

    // MARK: - Actions
    @objc
    private func didPullToRefresh() {
        reloadWebView()
    }

    // MARK: - Constraints
    private func setupLayouts() {
        view.addSubview(webView)
        view.addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showWKWebViewError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showWKWebViewError(error)
    }
}
