import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias NftsCompletion = (Result<[Nft], Error>) -> Void


protocol NftService {
    func loadNft(id: NftID, completion: @escaping NftCompletion)
    func loadNfts(ids: [NftID], completion: @escaping NftsCompletion)
}

final class NftServiceImpl: NftService {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNft(id: NftID, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadNfts(ids: [NftID], completion: @escaping NftsCompletion) {
        var loadedNfts: [Nft] = []
        var errors: [Error] = []
        let dispatchGroup = DispatchGroup()
        
        for id in ids {
            dispatchGroup.enter()
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    errors.append(error)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(loadedNfts))
            } else {
                completion(.failure(errors.first!))
            }
        }
    }
}
