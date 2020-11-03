//
//  GistDetailControllerTest.swift
//  iOS-ChallengeTests
//
//  Created by Derick Nazzoni on 02/11/20.
//

@testable import iOS_Challenge
import XCTest

class GistDetailControllerTest: BaseXCTest {
    fileprivate let provider = ProviderMock.sharedMock
    
    func testSnapshot() {
        
        //recordMode = true
        
        var gist = GistFeedModel()
        gist.owner?.avatarUrl =  "https://github.com/images/error/octocat_happy.gif"
        gist.owner?.login = "octocat"
        let controller = GistDetailViewController.instantiate(withGist: gist)
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.addSubview(controller.view)
        verifySnapshotView(delay: 1) {
            controller.view
        }
    }
}

private class ProviderMock: Provider {
    static let sharedMock = ProviderMock()
    
    init() {
        super.init(baseURL: "")
    }
    
    override func downloadImage(withImagePath imagePath:String, params: [String: String], completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let image = UIImage(named: "avatar") else {
            completionHandler(.failure(.generic))
            return
        }
        completionHandler(.success(image))
    }
}
