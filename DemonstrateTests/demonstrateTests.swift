//
//  demonstrateTests.swift
//  demonstrateTests
//
//  Created by Jawad Khadra on 5/9/24.
//

import XCTest
import SwiftUI
@testable import Demonstrate

final class demonstrateTests: XCTestCase {

    let authModel = AuthenticationViewModel()
    
    func testNonceResponse() {
        // Arrange
        
        
        // Act
        let firstNonce = authModel.randomNonceString()
        let secondNonce = authModel.randomNonceString()
        
        // Assert
        XCTAssertNotEqual(firstNonce, secondNonce)
    }
}
