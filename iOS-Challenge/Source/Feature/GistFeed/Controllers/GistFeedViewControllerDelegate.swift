//
//  GistFeedViewControllerCoordinator.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 02/11/20.
//

import Foundation

protocol GistFeedViewControllerDelegate: class {
    func wantsToShowDetail(gist: GistFeedModel)
}
