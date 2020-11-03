//
//  GistFeedOperations.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import Foundation

class GistFeedOperation: AsyncOperation {
    
    private let page: Int
    private let business: GistFeedBusinessProtocol
    private let provider: Provider
    private let completion: GistFeedCompletion
    
    required init(page: Int = 0,
                  business: GistFeedBusinessProtocol = GistFeedBusiness(),
                  provider: Provider = Provider.shared,
                  completion: @escaping GistFeedCompletion) {
        
        self.page = page
        self.business = business
        self.provider = provider
        self.completion = completion
    }
    
    override func main() {
        super.main()
        let query = "?page=\(page)"
        provider.request(to: query, method: .GET, params: [:]) { [weak self] result in
            guard let self = self else { return }
            self.business.handleResult(result: result, completion: self.completion)
            self.finish()
        }
    }
    
}
