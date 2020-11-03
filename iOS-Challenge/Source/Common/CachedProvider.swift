//
//  CachedProvider.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 02/11/20.
//

import UIKit

class CachedProvider: Provider {
    
    static let cachedShared = CachedProvider(baseURL: "")
    
    override func downloadImage(withImagePath imagePath: String, params: [String : String], completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        if let cachedImage = imageCache.object(forKey: imagePath as NSString) {
            completionHandler(.success(cachedImage))
            return
        }
        let imagePath = String(imagePath.split(separator: "/").last?.split(separator: "?").first ?? "")
        guard let savedImage = self.retrieveImage(forKey: imagePath) else {
            completionHandler(.failure(.noData))
            return
        }
        completionHandler(.success(savedImage))
    }
    
    override func request(to endpoint: String, method: NetworkMethod, params: [String : String], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let userDefaults = UserDefaults.standard
        do {
            let data = try userDefaults.getObject(forKey: "gistList")
            completionHandler(.success(data))
        } catch {
            completionHandler(.failure(NetworkError.noData))
        }
    }
    
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
}
