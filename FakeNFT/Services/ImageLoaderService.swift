//
//  ImageLoaderService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 23.02.2025.
//

import UIKit
import Kingfisher

protocol ImageLoaderService {
    func loadImage(into imageView: UIImageView, from url: URL?, placeholder: UIImage?, completion: ((Result<UIImage, Error>) -> Void)?)
    func loadImage(from url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void)
    func clearCache()
}

final class ImageLoaderServiceImpl: ImageLoaderService {

    func loadImage(
        into imageView: UIImageView,
        from url: URL?,
        placeholder: UIImage? = UIImage(systemName: "scribble"),
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.3))]
        ) { result in
            switch result {
            case .success(let value):
                completion?(.success(value.image))
            case .failure(let error):
                imageView.contentMode = .scaleAspectFit
                completion?(.failure(error))
#if DEBUG
                print("DEBUG: Failed to load image from \(String(describing: url)) – \(error.localizedDescription)")
#endif
            }
        }
    }

    func loadImage(from url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NSError(domain: "ImageLoaderService", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL is nil"])))
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(.success(value.image))
            case .failure(let error):
                completion(.failure(error))
#if DEBUG
                print("DEBUG: Failed to load image from \(url) – \(error.localizedDescription)")
#endif
            }
        }
    }

    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
#if DEBUG
            print("DEBUG: Image cache cleared")
#endif
        }
    }
}
