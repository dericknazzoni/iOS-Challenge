//
//  NibOwnerLoadable.swift
//  enjoy
//
//  Created by Derick Nazzoni on 27/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import UIKit

public protocol NibOwnerLoadable: AnyObject {
    
    static var nib: UINib { get }
}

extension NibOwnerLoadable {
    public static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibOwnerLoadable where Self: UIViewController {
    public static var fromNib: Self {
        return Self(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}
