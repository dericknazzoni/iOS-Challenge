//
//  GistDetailOperation.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 30/10/20.
//

import Foundation

class ImageDetailDownloadOperation: AsyncOperation {

    private let imagePath: String
    private let business: GistDetailBusinessProtocol
    private let provider: Provider
    private let completion: ImageCompletion
    
    required init(imagePath: String,
                  business: GistDetailBusinessProtocol = GistDetailBusiness(),
                  provider: Provider = Provider.shared,
                  completion: @escaping ImageCompletion) {
        self.imagePath = imagePath
        self.business = business
        self.provider = provider
        self.completion = completion
    }
    
    override func main() {
        super.main()
        provider.downloadImage(withImagePath: imagePath, params: [:]) {[weak self] result in
                guard let self = self else { return }
                self.business.handleImage(result: result, completion: self.completion)
                self.finish()
        }

    }
}
