//
//  GistDetailViewController.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 30/10/20.
//

import UIKit

class GistDetailViewController: UIViewController, Identifiable {
    
    private var gist: GistFeedModel?
    private var viewModel: GistDetailViewModelProtocol?
    private var spinner = UIView()
    
    @IBOutlet private weak var detailImageView: UIImageView?
    @IBOutlet private weak var usuarioLabel: UILabel?
    
    static func instantiate(withGist gist: GistFeedModel,
                            viewModel: GistDetailViewModelProtocol = GistDetailViewModel()) -> GistDetailViewController {
        
        let viewController: GistDetailViewController = UIStoryboard.viewController(from: .GistDetail, bundle: Bundle(for: self))
        viewController.gist = gist
        viewController.viewModel = viewModel
        return viewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gist Detail"
        setupView()
        usuarioLabel?.text = gist?.owner?.login
        bindElements()
        viewModel?.fetchImage(stringUrl: gist?.owner?.avatarUrl ?? "")
    }
    
    func bindElements(){
        viewModel?.image.bind(skip: true) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.detailImageView?.image = image
            }
            
        }
        viewModel?.loading.bind(skip: true) { [weak self] isLoading in
            guard let self = self, let imageView = self.detailImageView else { return }
            DispatchQueue.main.async {
                if isLoading {
                    self.spinner = UIViewController.displaySpinner(onView: imageView)
                    return
                }
                UIViewController.removeSpinner(spinner: self.spinner)
            }
        }
    }
    
    func setupView() {
        detailImageView?.layer.cornerRadius = 10
    }
    
    
//    private func setupOutlet() {
//        guard let owner = owner else { return }
//        detailImageView?.image = owner.avatarUrl
//    }
//    
}
