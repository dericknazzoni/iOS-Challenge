//
//  GistFeedControllerTest.swift
//  iOS-ChallengeTests
//
//  Created by Derick Nazzoni on 02/11/20.
//

@testable import iOS_Challenge
import XCTest

class GistFeedControllerTest: BaseXCTest {
    fileprivate let provider = ProviderMock.sharedMock
    
    func testSnapshot() {
        //recordMode = true

        
        let viewModel = GistFeedViewModel(manager: GistFeedManager(provider: provider))
        let controller = GistFeedViewController.instatiate(viewModel: viewModel)
        
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

    override func request(to endpoint: String, method: NetworkMethod, params: [String : String], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let data = FileRepresentation(withFileName: "GistSuccessResponse", fileExtension: .json, fileBundle: Bundle(for: ProviderMock.self)).data else {
            completionHandler(.failure(.generic))
            return
        }
        completionHandler(.success(data))
    }
    
    override func downloadImage(withImagePath imagePath:String, params: [String: String], completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let image = UIImage(named: "avatar") else {
            completionHandler(.failure(.generic))
            return
        }
        completionHandler(.success(image))
    }
}
