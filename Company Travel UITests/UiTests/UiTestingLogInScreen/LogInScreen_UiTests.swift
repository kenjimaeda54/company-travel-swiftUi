//
//  UITestingSigInScreen.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 26/09/23.
//

import Foundation
import XCTest

final class LogInScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!
  private var textFieldEmail: XCUIElement!
  private var textFieldPassword: XCUIElement!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()

    textFieldEmail = app.textViews["Insira seu email"]
    textFieldPassword = app.secureTextFields["Insira uma senha"]
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testEnableButtonRegisterIfAllFieldAreFilled() {
    let buttonRegister = app.buttons["Entrar"]

    textFieldEmail.tap()
    textFieldEmail.typeText("Joao@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")

    XCTAssertEqual(buttonRegister.isEnabled, true)
  }

  func testIfNavigateForSigInWhenPressButton() {
    let buttonRegister = app.buttons["Não possui conta, clique aqui e registre"]

    buttonRegister.tap()

    let textSigIn = app.staticTexts["Clique na imagem acima para selecionar uma foto"]

    XCTAssertTrue(textSigIn.exists)
  }

  func testErrorMessageIfEmailWrong() {
    let messageError = app.staticTexts["Tem certeza que possui registro e sua senha ou e-mail estão corretos?"]
    let buttonRegister = app.buttons["Entrar"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenjiMaedafamily3@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")

    buttonRegister.tap()

    XCTAssertTrue(messageError.exists)
  }

  func testErrorMessageIfPasswordWrong() {
    let messageError = app.staticTexts["Tem certeza que possui registro e sua senha ou e-mail estão corretos?"]
    let buttonRegister = app.buttons["Entrar"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacatefdf54@")

    buttonRegister.tap()

    XCTAssertTrue(messageError.exists)
  }

  func testSucessLogiInIfPasswordAndEmailIsCorrect() {
    let textNameHomeScreen = app
      .staticTexts["Ola Carlos, "] // nome vai depender do usuario salvo file
    // namager
    let buttonRegister = app.buttons["Entrar"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")

    buttonRegister.tap()

    XCTAssertTrue(textNameHomeScreen.exists)
  }
}
