//
//  GistFeedBusiness.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

protocol GistFeedBusinessProtocol {
    func handleResult(result: Result<Data, NetworkError>, completion: GistFeedCompletion)
    func handleImage(result: Result<UIImage, NetworkError>, completion: ImageCompletion)
}

class GistFeedBusiness: GistFeedBusinessProtocol {
    
    func handleResult(result: Result<Data, NetworkError>, completion: (@escaping () throws -> [GistFeedModel]) -> Void) {
        switch result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode([GistFeedModel].self, from: data)
                let gists = response
                completion { gists }
            
            } catch {
                completion { throw NetworkError.parseError }
            }
            
        case .failure(let error):
            completion { throw error }
        }
    }
    
    func handleImage(result: Result<UIImage, NetworkError>, completion: (@escaping () throws -> UIImage) -> Void) {
        switch result {
        case .success(let image):
            completion { image }
        case .failure(let error):
            completion { throw error }
        }
    }
    
}
