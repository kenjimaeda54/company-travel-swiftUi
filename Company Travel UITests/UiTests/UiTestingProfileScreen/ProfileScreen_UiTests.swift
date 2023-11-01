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

  // tentar amanha pegar a foto e atualizar metade de um
  // pomodoro para pegar
  func testRenderCorrectDataWhenClickedProfile() {
    let imageAvatar = app.buttons["https://github.com/kenjimaeda54.png"]
    let predicateName =
      NSPredicate(format: "identifier == 'Carlos'")
    let name = app.descendants(matching: .any).matching(predicateName).firstMatch

    XCTAssertTrue(name.exists)
    XCTAssertTrue(imageAvatar.exists)
  }

  func testUpdateUserName() {
    let predicateName =
      NSPredicate(format: "identifier == 'Maeda'")
    let buttonUpdate = app.buttons["Atualizar"]
    let predicateButtonHome = NSPredicate(format: "identifier == 'house'")
    let buttonHome = app.descendants(matching: .any).matching(predicateButtonHome).firstMatch
    let textFieldName = app.descendants(matching: .any).matching(predicateName).firstMatch
    let nameText = app.staticTexts["Ola Carlos, "]
    textFieldName.tap()
    textFieldName.typeText("Carlos")
    buttonUpdate.tap()
    buttonHome.tap()
    XCTAssertTrue(nameText.waitForExistence(timeout: 3))
  }
}
