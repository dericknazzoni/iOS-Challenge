//
//  Provider.swift
//  enjoy
//
//  Created by Derick Nazzoni on 26/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import UIKit
    
class Provider {
    // MARK: - Singleton
    static let shared = Provider(baseURL: "https://api.github.com/gists/public")
    
    // MARK: - Properties
    private let baseURL: String
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Initialization
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // MARK: - Public Methods
    func request(to endpoint:String, method: NetworkMethod, params: [String: String], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlComponents = URLComponents(string: Provider.shared.baseURL + endpoint) else {
            completionHandler(.failure(.badURL))
            return
        }
        guard let url = urlComponents.url else {
            completionHandler(.failure(.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        _ = params.map { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        if method == .POST || method == .PUT {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                completionHandler(.failure(.noData))
                return
            }
            guard error == nil else {
                completionHandler(.failure(.generic))
                return
            }
            print(String(data: responseData, encoding: String.Encoding.utf8) ?? String())
            completionHandler(.success(responseData))
        }
        task.resume()
    }
    
    // MARK: - Public Methods
    func requestImage(to endpoint:String, method: NetworkMethod, params: [String: String], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlComponents = URLComponents(string: endpoint) else {
            completionHandler(.failure(.badURL))
            return
        }
        guard let url = urlComponents.url else {
            completionHandler(.failure(.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        _ = params.map { urlRequest.addValue($1, forHTTPHeaderField: $0) }
        if method == .POST || method == .PUT {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                completionHandler(.failure(.noData))
                return
            }
            guard error == nil else {
                completionHandler(.failure(.generic))
                return
            }
            print(String(data: responseData, encoding: String.Encoding.utf8) ?? String())
            completionHandler(.success(responseData))
        }
        task.resume()
    }
    
    func downloadImage(withImagePath imagePath:String, params: [String: String], completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        if let cachedImage = imageCache.object(forKey: imagePath as NSString) {
            completionHandler(.success(cachedImage))
            return
        }
        guard var urlComponents = URLComponents(string: imagePath) else {
            completionHandler(.failure(.badURL))
            return
        }
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        guard let url = urlComponents.url else {
            completionHandler(.failure(.badURL))
            return
        }
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { (location, response, error) in
            guard let locationUrl = location, let data = try? Data(contentsOf: locationUrl) else {
                completionHandler(.failure(.noData))
                return
            }
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(.parseError))
                return
            }
            guard error == nil else {
                completionHandler(.failure(.generic))
                return
            }
            self.imageCache.setObject(image, forKey: imagePath as NSString)
            completionHandler(.success(image))
        }
        downloadTask.resume()
    }
    
}

enum NetworkError: Error {
    case badURL
    case parseError
    case noData
    case connection
    case generic
}

enum NetworkMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

