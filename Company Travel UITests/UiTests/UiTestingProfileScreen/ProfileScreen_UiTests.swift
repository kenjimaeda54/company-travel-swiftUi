//
//  ProfileScreen_UiTests.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 30/10/23.
//

import Foundation
import XCTest

final class ProfileScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!
  let currentName = "Maeda"
  let changeName = "Carlos"

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()

    let buttonRegister = app.buttons["Entrar"]

    let textFieldEmail = app.textViews["Insira seu email"]
    let textFieldPassword = app.secureTextFields["Insira uma senha"]
    let profile = app.buttons["config"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")
    buttonRegister.tap()
    profile.tap()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testUpdateUserName() {
    let predicateName =
      NSPredicate(format: "identifier == 'Maeda'")
    let buttonUpdate = app.buttons["Atualizar"]
    let predicateButtonHome = NSPredicate(format: "identifier == 'house'")
    let buttonHome = app.descendants(matching: .any).matching(predicateButtonHome).firstMatch
    let textFieldName = app.descendants(matching: .any).matching(predicateName).firstMatch
    let nameText = app.staticTexts["Ola Carlos, "]
    let profile = app.buttons["config"]
    textFieldName.tap()
    textFieldName.typeText("Carlos")
    buttonUpdate.tap()
    buttonHome.tap()
    XCTAssertTrue(nameText.waitForExistence(timeout: 3))
  }
}
