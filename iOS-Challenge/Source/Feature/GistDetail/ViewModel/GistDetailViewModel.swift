//
//  GistDetailViewModel.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 02/11/20.
//

import UIKit

protocol GistDetailViewModelProtocol {
    var loading: Bindable<Bool> { get set }
    var connectionError: Bindable<Bool> { get set }
    var image: Bindable<UIImage?> { get set }
    
    func fetchImage(stringUrl: String)
}

class GistDetailViewModel: GistDetailViewModelProtocol {
    
    var loading = Bindable<Bool>(false)
    var connectionError = Bindable<Bool>(false)
    var image =  Bindable<UIImage?>(nil)
    private var manager: GistDetailManagerProtocol
    
    init(manager: GistDetailManagerProtocol = GistDetailManager()) {
        self.manager = manager
    }
    
    
    func fetchImage(stringUrl: String) {
        loading.value = true
        manager.fetchImage(imagePath: stringUrl) { [weak self] result in
            guard let self = self else { return }
            self.loading.value = false
            do {
                let result = try result()
                self.image.value = result
            } catch {
                self.image.value = UIImage()
            }
        }
    }
}

