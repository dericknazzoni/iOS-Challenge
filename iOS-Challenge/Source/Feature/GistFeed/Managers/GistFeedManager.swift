//
//  GistFeedManager.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

typealias GistFeedCompletion = (@escaping () throws -> [GistFeedModel]) -> Void
typealias ImageCompletion = (@escaping () throws -> UIImage) -> Void

protocol GistFeedManagerProtocol {
    func fetchGistFeed(page: Int, completion: @escaping GistFeedCompletion)
    func fetchImage(imagePath: String, completion: @escaping ImageCompletion)
}

class GistFeedManager: Manager, GistFeedManagerProtocol {

    private let provider: Provider
    private let business: GistFeedBusinessProtocol
    
    required init(provider: Provider = Provider.shared,
                  business: GistFeedBusinessProtocol = GistFeedBusiness()) {
        self.provider = provider
        self.business = business
    }
    
    func fetchGistFeed(page: Int, completion: @escaping GistFeedCompletion) {
        let operation = GistFeedOperation(page: page, business: business, provider: provider, completion: completion)
        addOperation(operation)
    }
    
    func fetchImage(imagePath: String, completion: @escaping ImageCompletion) {
        let operation = ImageDownloadOperation(imagePath: imagePath, business: business, provider: provider, completion: completion)
        addOperation(operation)
    }
}
