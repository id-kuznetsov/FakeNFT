//
//  WebViewModel.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 24.02.2025.
//

import Foundation

protocol WebViewViewModelProtocol {
    func getRequest() -> URLRequest
}

enum WebViewError: LocalizedError {
    case apiBug
}

final class WebViewViewModel {
    private let url: URL

    init(url: URL) {
        self.url = url
    }
}

extension WebViewViewModel: WebViewViewModelProtocol {
    func getRequest() -> URLRequest {
        return URLRequest(url: url)
    }
}
