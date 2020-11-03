//
//  GistFeedCellTest.swift
//  iOS-ChallengeTests
//
//  Created by Derick Nazzoni on 02/11/20.
//

@testable import iOS_Challenge
import XCTest

class DashboardCellTests: BaseXCTest {
    
    func testSnapshot() {
        //recordMode = true

        guard let cell = GistFeedCell.fromNib() as? GistFeedCell else {
            return assertionFailure()
        }
        cell.frame = CGRect(x: 0, y: 0, width: 300, height: 310)
        cell.setup(image: UIImage(named: "avatar"), name: "anujdeep")
        verifySnapshotView {
            cell
        }
    }
}
