//
//  UITestingSigInScreen.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 26/09/23.
//

import Foundation
import XCTest

final class LogInScreen_UiTests: XCTestCase {
  var app: XCUIApplication!

  override func setUp() async throws {
    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()
  }

  override func tearDown() async throws {
    app = nil
  }
}
