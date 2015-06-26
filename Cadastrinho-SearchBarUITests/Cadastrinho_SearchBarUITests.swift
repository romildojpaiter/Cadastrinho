//
//  Cadastrinho_SearchBarUITests.swift
//  Cadastrinho-SearchBarUITests
//
//  Created by Danilo Altheman on 25/06/15.
//  Copyright © 2015 Quaddro - Danilo Altheman. All rights reserved.
//

import Foundation
import XCTest

class Cadastrinho_SearchBarUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
