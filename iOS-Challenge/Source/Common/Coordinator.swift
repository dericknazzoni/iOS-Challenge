//
//  Coordinator.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    
}

