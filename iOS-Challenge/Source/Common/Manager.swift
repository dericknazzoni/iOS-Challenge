//
//  Manager.swift
//  enjoy
//
//  Created by Derick Nazzoni on 27/07/20.
//  Copyright © 2020 enjoei. All rights reserved.
//

import Foundation

class Manager: OperationQueue {
    
    public override init() {
        super.init()
    }
    
    deinit {
        cancelAllOperations()
    }
    
}
