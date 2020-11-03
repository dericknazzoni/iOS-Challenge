//
//  Collection.swift
//  enjoy
//
//  Created by Derick Nazzoni on 27/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
