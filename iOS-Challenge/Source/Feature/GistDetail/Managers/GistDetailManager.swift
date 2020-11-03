//
//  GistDetailManager.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 30/10/20.
//

import UIKit

protocol GistDetailManagerProtocol {
    func fetchImage(imagePath: String, completion: @escaping ImageCompletion)
}

class GistDetailManager: Manager, GistDetailManagerProtocol {

    private let provider: Provider
    private let business: GistDetailBusinessProtocol
    
    required init(provider: Provider = Provider.shared,
                  business: GistDetailBusinessProtocol = GistDetailBusiness()) {
        self.provider = provider
        self.business = business as! GistDetailBusiness
    }

    
    func fetchImage(imagePath: String, completion: @escaping ImageCompletion) {
        let operation = ImageDetailDownloadOperation(imagePath: imagePath, business: business, provider: provider, completion: completion)
        addOperation(operation)
    }
}
