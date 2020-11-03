//
//  Identifiable.swift
//  enjoy
//
//  Created by Derick Nazzoni on 26/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import UIKit

public protocol Identifiable: class { }

public protocol NibLoadableView: class { }

public extension Identifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static var segueIdentifier: String {
        let identifier = String(describing: self)
        let vcString = "ViewController"
        let endIndex = identifier.index(identifier.endIndex, offsetBy: -vcString.count)
        return String(identifier[identifier.startIndex..<endIndex])
    }
}

public extension Identifiable where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension Identifiable where Self: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
}

