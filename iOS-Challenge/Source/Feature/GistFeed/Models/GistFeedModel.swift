//
//  GistFeedModel.swift
//  iOS-Challenge
//
//  Created by Derick Nazzoni on 29/10/20.
//

import UIKit

struct GistFeedModel: Codable, Equatable {
    var owner: Owner?
    var id: String?
    
    static func == (lhs: GistFeedModel, rhs: GistFeedModel) -> Bool {
        return lhs.id == rhs.id
    }
}
