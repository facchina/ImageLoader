//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by Kaike Facchina on 18/03/22.
//
import Foundation
import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(at url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image: UIImage = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        
        let uuid: UUID = .init()
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, _, error in

            defer {self.runningRequests.removeValue(forKey: uuid) }
            
            if let data: Data = data, let image: UIImage = .init(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            
            guard let error: NSError = error as NSError?,
                  error.code != NSURLErrorCancelled else { return }
            
            completion(.failure(error))
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(for uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
