//
//  GistFeedCoordinator.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

class GistFeedCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [getGistFeedController(),
                                            getCachedGistFeedController()]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func getGistFeedController() -> UIViewController {
        let controller = GistFeedViewController.instatiate()
        controller.delegate = self
        let item = UITabBarItem()
        item.title = "Gist List"
        item.image = UIImage(named: "lista")
        controller.tabBarItem = item
        return controller
    }
    
    private func getCachedGistFeedController() -> UIViewController {
        let manager = GistFeedManager(provider: CachedProvider.cachedShared)
        let viewModel = GistFeedViewModel(manager: manager)
        let controller = GistFeedViewController.instatiate(viewModel: viewModel)
        controller.delegate = self
        let item = UITabBarItem()
        item.title = "Gist cached"
        item.image = UIImage(named: "lista")
        controller.tabBarItem = item
        return controller
    }
    
}

extension GistFeedCoordinator: GistFeedViewControllerDelegate {
    
    func wantsToShowDetail(gist: GistFeedModel) {
        let coord = GistDetailCoordinator(navigationController: navigationController, gist: gist)
        childCoordinators.append(coord)
        coord.start()
    }
}
