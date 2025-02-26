import Foundation
import UIKit

// MARK: - Protocol

protocol NftDetailPresenter {
    func viewDidLoad()
}

// MARK: - State

enum NftDetailState {
    case initial, loading, failed(Error), data(Nft)
}

final class NftDetailPresenterImpl: NftDetailPresenter {

    // MARK: - Properties

    weak var view: NftDetailView?
    private let input: NftDetailInput
    private let service: NftService
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(input: NftDetailInput, service: NftService) {
        self.input = input
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNft()
        case .data(let nft):
            view?.hideLoading()
            let cellModels = nft.images.map { NftDetailCellModel(url: $0) }
            view?.displayCells(cellModels)
        case .failed(let error):
            view?.hideLoading()
            view?.showError(error)
        }
    }

    private func loadNft() {
        service.loadNft(id: input.id) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.state = .data(nft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
