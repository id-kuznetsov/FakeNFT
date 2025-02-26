//
//  ImageLoaderService.swift
//  FakeNFT
//
//  Created by Nikolai Eremenko on 23.02.2025.
//

import UIKit
import Kingfisher

protocol ImageLoaderService {
    func loadImage(
        into imageView: UIImageView,
        from url: URL?,
        completion: @escaping (Result<UIImage, Error>) -> Void
    )

    func clearCache()
}

final class ImageLoaderServiceImpl: ImageLoaderService {
    func loadImage(
        into imageView: UIImageView,
        from url: URL?,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        let placeholder: UIImage? = .scribble
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.3))]
        ) { result in
            switch result {
            case .success(let value):
                completion(.success(value.image))
            case .failure(let error):
                imageView.contentMode = .scaleAspectFit
                completion(.failure(error))
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
