//
//  UIView.swift
//  PopularMoviesTests
//
//  Created by Ricardo Sousa on 17/12/19.
//  Copyright © 2019 Ricardo Sousa. All rights reserved.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(frame.size)
            guard let contextImage = UIGraphicsGetCurrentContext() else { return UIImage() }
            layer.render(in: contextImage)
            guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return UIImage() }
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image)
        }
    }
}
