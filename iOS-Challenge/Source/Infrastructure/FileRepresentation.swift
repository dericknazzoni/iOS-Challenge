//
//  FileRepresentation.swift
//  PopularMovies
//
//  Created by Ricardo Sousa on 17/12/19.
//  Copyright © 2019 Ricardo Sousa. All rights reserved.
//

import Foundation

struct FileRepresentation {
    enum FileRepresentationError: Error {
        case invalidData
    }
    
    enum Extension: String {
        case json
        case html
        case pdf
    }
    
    private var fileName: String?
    private var fileExtension: Extension?
    private var fileBundle: Bundle?
    private var fileData: Data?
    var path: String? {
        guard let url = fileBundle?.url(forResource: fileName ?? String(), withExtension: fileExtension?.rawValue ?? String()) else { return String() }
        return url.absoluteString
    }
    
    var data: Data? {
        if let data = fileData {
            return data
        }
        
        guard let url = fileBundle?.url(forResource: fileName ?? String(), withExtension: fileExtension?.rawValue ?? String()) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        return data
    }

    init(withFileName fileName: String, fileExtension: Extension, fileBundle: Bundle) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.fileBundle = fileBundle
    }

    init(withFileData fileData: Data) {
        self.fileData = fileData
    }

    func decoded<T: Decodable>(to type: T.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        guard let data = data else { throw FileRepresentationError.invalidData }
        return try decoder.decode(type, from: data)
    }
}

