//
//  SigInScreen_UiTests.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 22/09/23.
//

@testable import Company_Travel
import Foundation
import XCTest

final class SigInScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!
  private var buttonRegisterUser: XCUIElement!
  private var textFieldName: XCUIElement!
  private var textFieldEmail: XCUIElement!
  private var textFieldPassword: XCUIElement!
  private var buttonAvatar: XCUIElement!
  private var buttonSheetGallery: XCUIElement!
  private var sheetPhotoLibrary: XCUIElement!
  private var imagePickerLibrary: XCUIElement!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "SIGIN"]
    app.launch()

    buttonRegisterUser = app.buttons["Cadastrar"]
    textFieldName = findLabelAndReturnElement("Name")
    textFieldEmail = findLabelAndReturnElement("Email")
    textFieldPassword = findLabelAndReturnElement("Password")
    let predicateButtonAvatar = NSPredicate(format: "identifier == 'ButtonAvatar'")
    buttonAvatar = app.descendants(matching: .any).matching(predicateButtonAvatar).firstMatch
    buttonSheetGallery = app.buttons["Pegar foto da galeria"]
    sheetPhotoLibrary = app.otherElements["SheetSelectedPhotoLibrary"]
    imagePickerLibrary = app.otherElements["ImagePickerLibrary"]
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testEnableButtonIfAllFieldsAreFieldIn() {
    XCTAssertTrue(buttonRegisterUser.exists)
    XCTAssert(buttonAvatar.exists)
    textFieldName.tap()
    textFieldName.typeText("Pedro")

    XCTAssertEqual(buttonRegisterUser.isEnabled, false)

    textFieldEmail.tap()
    textFieldEmail.typeText("Joao@gmail.com")

    XCTAssertEqual(buttonRegisterUser.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54$")

    XCTAssertEqual(buttonRegisterUser.isEnabled, false)

    buttonAvatar.tap()
    XCTAssertTrue(buttonSheetGallery.exists)

    // MARK: - Test sheet gallery

    buttonSheetGallery.tap()
    XCTAssertTrue(sheetPhotoLibrary.exists)
    XCTAssertTrue(imagePickerLibrary.exists)
    imagePickerLibrary.images["Photo, 30 March 2018, 16:14"]
      .tap() // precisa pegar a referencia da foto e dar um tap que seria o click, primeira foto da galeria esta
//    // referencia, essa referencia depende do tipo de linguagem que esta no sistema, este modo e internacional ou
//    /ingles

    XCTAssertEqual(buttonRegisterUser.waitForExistence(timeout: 3), true)
  }

  func testTypeEmailWrong() {
    let nextButton = app.buttons["Next:"] // depois que atulizou para ios17
    let textFailedEmail = app.staticTexts["Precisa ser um email valido"]

    textFieldEmail.tap()
    textFieldEmail.typeText("Joao@.gmail.com")
    nextButton.tap()

    XCTAssertTrue(textFailedEmail.exists)
  }

  func testTypePasswordWrong() {
    let doneButton = app.buttons["Done"]
    let textFailedPassword = app
      .staticTexts["Senha precisa ser no mínimo 8 palavras, um maiúsculo, um dígito é um especial"]

    textFieldPassword.tap()
    textFieldPassword.typeText("abacate54%") // cuidado # nao e permitido
    doneButton.tap()

    XCTAssertTrue(textFailedPassword.exists)
  }

  func testTypeEmailRegistered() {
    let emailFailed = app.staticTexts["Ops! Este email ja foi registrado"]

    textFieldName.tap()
    textFieldName.typeText("Pedro")

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54$")

    buttonAvatar.tap()

    XCTAssertTrue(buttonSheetGallery.exists)

    buttonSheetGallery.tap()
    imagePickerLibrary.images["Photo, 30 March 2018, 16:14"]
      .tap()

    buttonRegisterUser.tap()

    XCTAssertTrue(emailFailed.exists)
  }

  func testRegisterUserWithSuccess() {
    let registerUserSuccess = app.staticTexts["Ola Pedro, "]

    textFieldName.tap()
    textFieldName.typeText("Pedro")

    textFieldEmail.tap()
    textFieldEmail.typeText("Pedro@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54$")

    buttonAvatar.tap()

    XCTAssertTrue(buttonSheetGallery.exists)

    buttonSheetGallery.tap()
    imagePickerLibrary.images["Photo, 30 March 2018, 16:14"]
      .tap()

    buttonRegisterUser.tap()

    XCTAssertTrue(registerUserSuccess.waitForExistence(timeout: 5))
  }
}

extension SigInScreen_UiTests {
  func findLabelAndReturnElement(_ label: String) -> XCUIElement {
    let predicate = NSPredicate(format: "label == '\(label)'")
    return app.descendants(matching: .any).matching(predicate).firstMatch
  }

  // exemplo como retornar varios elementos
//  func returnElementsFormAndExecuteUserRegistrationFlow(typeName: String, typeEmail: String, typePassword: String)
//  -> [String: XCUIElement] {
//    let buttonRegisterUser = app.buttons["Cadastrar"]
//    let textFieldName = findLabelAndReturnElement("Name")
//    let textFieldEmail = findLabelAndReturnElement("Email")
//    let textFieldPassword = findLabelAndReturnElement("Password")
//    let predicateButtonAvatar = NSPredicate(format: "identifier == 'ButtonAvatar'")
//    let buttonAvatar = app.descendants(matching: .any).matching(predicateButtonAvatar).firstMatch
//    let buttonSheetGallery = app.buttons["Pegar foto da galeria"]
//    let sheetPhotoLibrary = app.otherElements["SheetSelectedPhotoLibrary"]
//    let imagePickerLibrary = app.otherElements["ImagePickerLibrary"]
//
//
//
//    return [
//      "buttonRegisterUser": buttonRegisterUser,
//      "textFieldName": textFieldName,
//      "textFieldEmail": textFieldEmail,
//      "textFieldPassword": textFieldPassword,
//      "buttonAvatar": buttonAvatar,
//      "buttonSheetGallery": buttonSheetGallery,
//      "sheetPhotoLibrary": sheetPhotoLibrary,
//      "imagePickerLibrary": imagePickerLibrary
//    ]
//  }
}
