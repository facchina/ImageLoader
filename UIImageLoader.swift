//
//  UIImageLoader.swift
//  ImageLoader
//
//  Created by Kaike Facchina on 18/03/22.
//

import Foundation
import UIKit

class UIImageLoader {
    static let loader: UIImageLoader = .init()
    private let imageLoader: ImageLoader = .init()
    
    private var imageViewUUIDs: [UIImageView: UUID] = .init()
    
    func load(_ url: URL, for imageView: UIImageView) {
        let uuid: UUID? = imageLoader.loadImage(at: url, completion: { result in
                                                            
            defer { self.imageViewUUIDs.removeValue(forKey: imageView) }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
            case .failure(let error):
                debugPrint("error \(error.localizedDescription)")
            }
        })
        
        if let uuid = uuid {
            imageViewUUIDs[imageView] = uuid
        }
    }
    
    func cancel(for imageView: UIImageView) {
        guard let imageUUID: UUID = imageViewUUIDs[imageView] else { return }
        imageLoader.cancelLoad(for: imageUUID)
        imageViewUUIDs.removeValue(forKey: imageView)
    }
}
