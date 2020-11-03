//
//  GistDetailBusiness.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 30/10/20.
//

import UIKit

protocol GistDetailBusinessProtocol {
    func handleImage(result: Result<UIImage, NetworkError>, completion: ImageCompletion)
}

class GistDetailBusiness: GistDetailBusinessProtocol {
    
    func handleImage(result: Result<UIImage, NetworkError>, completion: (@escaping () throws -> UIImage) -> Void) {
        switch result {
        case .success(let image):
            completion { image }
        case .failure(let error):
            completion { throw error }
        }
    }
    
}
