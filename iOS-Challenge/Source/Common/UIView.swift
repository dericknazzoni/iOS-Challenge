//
//  UIView.swift
//  enjoy
//
//  Created by Derick Nazzoni on 27/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import UIKit

extension UIView {
    
    static func fromNib<T>(withOwner owner: Any? = nil, options: [AnyHashable: Any]? = nil) -> T? where T:UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        return nib.instantiate(withOwner: owner, options: options as? [UINib.OptionsKey: Any]).first as? T
    }

    func addSubviewAttachingEdges(_ view: UIView,
                                  verticalConstraint: String = "V:|[view]|",
                                  horizontalConstraint: String = "H:|[view]|") {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        attachEdges(view, verticalConstraint: verticalConstraint, horizontalConstraint: horizontalConstraint)
    }
    
    func attachEdges(_ view: UIView,
                     verticalConstraint: String? = "V:|[view]|",
                     horizontalConstraint: String? = "H:|[view]|",
                     views: [String: Any]? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = views ?? ["view": view]
        if let vertical = verticalConstraint {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vertical,
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewDictionary))
        }
        if let horizontal = horizontalConstraint {
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontal,
                                                          options: [],
                                                          metrics: nil,
                                                          views: viewDictionary))
        }
    }
}
