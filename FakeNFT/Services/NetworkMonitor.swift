//
//  NetworkMonitor.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 05.03.2025.
//

import Network
import Combine
import Foundation

protocol NetworkMonitor {
    var isConnected: Bool { get }
    var connectivityPublisher: AnyPublisher<Bool, Never> { get }
}

enum NetworkMonitorError: LocalizedError {
    case noInternetConnection
}

final class NetworkMonitorImpl: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let subject: CurrentValueSubject<Bool, Never>

    var isConnected: Bool {
        return subject.value
    }

    var connectivityPublisher: AnyPublisher<Bool, Never> {
        return subject.eraseToAnyPublisher()
    }

    init() {
        subject = CurrentValueSubject<Bool, Never>(false)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.subject.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
}
