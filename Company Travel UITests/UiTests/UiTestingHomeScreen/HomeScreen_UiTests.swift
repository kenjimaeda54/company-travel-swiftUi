//
//  HomeScreen_Tests.swift
//  Company Travel_Tests
//
//  Created by kenjimaeda on 20/09/23.
//

@testable import Company_Travel
import Foundation
import SwiftUI
import XCTest

final class HomeScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "HOME"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  
  func testExistsGridDestionationAndCorrectRenderItens() {
    let grid = app.otherElements["GridHomeDestination"]
    XCTAssertTrue(grid.waitForExistence(timeout: 5))

    let texasText = app.staticTexts["Texas, E.U.A"]
    let newYorkText = app.staticTexts["New York, E.U.A"]
    let kamatakaText = app.staticTexts["Kamataka, India"]

    XCTAssertTrue(texasText.exists)
    XCTAssertTrue(newYorkText.exists)
    XCTAssertTrue(kamatakaText.exists)
  }
	
	func testRenderNameUser()  {
		let nameText = app.staticTexts["Hi Bella,"]
		
		XCTAssertTrue(nameText.exists)
	}
	
	
}
