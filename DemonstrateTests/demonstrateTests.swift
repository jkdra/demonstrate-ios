//
//  demonstrateTests.swift
//  demonstrateTests
//
//  Created by Jawad Khadra on 5/9/24.
//

import XCTest
@testable import Demonstrate

final class demonstrateTests: XCTestCase {

    func testNonceResponse() {
        // Arrange
        let authModel = AuthenticationViewModel()
        
        // Act
        let firstNonce = authModel.randomNonceString()
        let secondNonce = authModel.randomNonceString()
        
        // Assert
        XCTAssertNotEqual(firstNonce, secondNonce)
    }
    
    func testUsernameCheck() {
        // Arrange
        
        // Act
        
        // Assert
    }
}
