//
//  UiStoryBoard.swift
//  enjoy
//
//  Created by Derick Nazzoni on 26/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Name: String {
        case GistFeed = "GistFeed"
        case GistDetail = "GistDetail"
     }

     static func viewController<T: UIViewController>(from storyboard: UIStoryboard.Name, bundle: Bundle) -> T where T: Identifiable {
         let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
         guard let viewController = storyboard.instantiateViewController(withIdentifier: T.self.storyboardIdentifier) as? T else {
             fatalError("Could not instantiate ViewController with identifier: \(T.storyboardIdentifier)")
         }
         
         return viewController
     }
     
     static func viewController<T: UIViewController>(from storyboard: UIStoryboard.Name, bundle: Bundle, id: String) -> T {
         let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: bundle)
         guard let viewController = storyboard.instantiateViewController(withIdentifier: id) as? T else {
             fatalError("Could not instantiate ViewController with identifier: \(id)")
         }
         
         return viewController
     }

}
