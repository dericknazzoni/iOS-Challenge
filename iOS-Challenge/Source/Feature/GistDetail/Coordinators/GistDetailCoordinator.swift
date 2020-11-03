//
//  GistDetailCoordinator.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 30/10/20.
//

import UIKit

class GistDetailCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var gist: GistFeedModel

    init(navigationController: UINavigationController, gist: GistFeedModel) {
        self.navigationController = navigationController
        self.gist = gist
    }

    func start() {
        let controller = GistDetailViewController.instantiate(withGist: gist)
        navigationController.pushViewController(controller, animated: true)
    }

    
}
