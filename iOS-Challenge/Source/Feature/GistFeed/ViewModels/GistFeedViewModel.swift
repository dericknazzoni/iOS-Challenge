//
//  GistFeedViewModel.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

protocol GistFeedViewModelProtocol {
    var loading: Bindable<Bool> { get set }
    var gists: Bindable<[GistFeedModel]> { get set }
    var connectionError: Bindable<Bool> { get set }
    var image: Bindable<(image: UIImage, row: Int)?> { get set }
    var imageLoading: Bindable<(loading: Bool, row: Int)?> { get set }
    
    func fetchGistFeed(page: Int)
    func fetchImage(forRow row: Int, stringUrl: String)
}

class GistFeedViewModel: GistFeedViewModelProtocol {

    var loading = Bindable<Bool>(false)
    var gists = Bindable<[GistFeedModel]>([])
    var connectionError = Bindable<Bool>(false)
    var image = Bindable<(image: UIImage, row: Int)?>(nil)
    var imageLoading = Bindable<(loading: Bool, row: Int)?>(nil)
    
    private var lastResponse = [GistFeedModel]()
    private var lastPage = 0
    
    private let manager: GistFeedManagerProtocol
    init(manager: GistFeedManagerProtocol = GistFeedManager()) {
        self.manager = manager
    }
    
    func fetchGistFeed(page: Int) {
        loading.value = true
        manager.fetchGistFeed(page: page) { [weak self] result in
            guard let self = self else { return }
            self.loading.value = false
            do {
                let result = try result()
                if page > self.lastPage && self.lastResponse == result {
                    return
                }
                self.lastPage = page
                self.lastResponse = result
                self.gists.value = result
            } catch {
                self.connectionError.value = true
            }
        }
    }
    
    func fetchImage(forRow row: Int, stringUrl: String) {
        imageLoading.value = (true, row)
        manager.fetchImage(imagePath: stringUrl) { [weak self] result in
            guard let self = self else { return }
            self.imageLoading.value = (false, row)
            do {
                let result = try result()
                self.image.value = (result, row)
            } catch {
                self.image.value = (UIImage(), row)
            }
        }
    }
}
