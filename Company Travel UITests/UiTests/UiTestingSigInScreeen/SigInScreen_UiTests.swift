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

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "SIGIN"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testEnableButtonIfAllFieldsAreFieldIn() {
    let buttonRegisterUser = app.buttons["Cadastrar"]
    let textFieldName = findLabelAndReturnElement("Name")
    let textFieldEmail = findLabelAndReturnElement("Email")
    let textFieldPassword = findLabelAndReturnElement("Password")
    let predicateButtonAvatar = NSPredicate(format: "identifier == 'ButtonAvatar'")
    let buttonAvatar = app.descendants(matching: .any).matching(predicateButtonAvatar).firstMatch
    let buttonSheetGallery = app.buttons["Pegar foto da galeria"]
    let sheetPhotoLibrary = app.otherElements["SheetSelectedPhotoLibrary"]
    let imagePickerLibrary = app.otherElements["ImagePickerLibrary"]

    XCTAssertTrue(textFieldName.exists)
    XCTAssertTrue(textFieldEmail.exists)
    XCTAssertTrue(buttonRegisterUser.exists)
    XCTAssert(buttonAvatar.exists)

    textFieldName.tap()
    textFieldName.typeText("Pedro")

    textFieldEmail.tap()
    textFieldEmail.typeText("Joao@gmail.com")

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54#")

    buttonAvatar.tap()

    XCTAssertTrue(buttonSheetGallery.exists)

    // MARK: - Test sheet gallery

    buttonSheetGallery.tap()
    XCTAssertTrue(sheetPhotoLibrary.exists)
    XCTAssertTrue(imagePickerLibrary.exists)
    imagePickerLibrary.images["Photo, March 30, 2018, 4:14 PM"]
      .tap() // precisa pegar a referencia da foto e dar um tap que seria o click, primeira foto da galeria esta
    // referencia

    XCTAssertEqual(buttonRegisterUser.isEnabled, true)
  }

  func testTypeEmailWrong() {
    let textEmail = findLabelAndReturnElement("Email")
    let nextButton = app.buttons["next"]
    let doneButton = app.buttons["done"]
    let textFailedEmail = app.staticTexts["Precisa ser um email valido"]

    textEmail.tap()
    textEmail.typeText("Joao@.gmail.com")
    nextButton.tap()
    doneButton.tap()

    XCTAssertTrue(textFailedEmail.exists)
  }

  func testTypePasswordWrong() {
    let textPassword = findLabelAndReturnElement("Password")
    let doneButton = app.buttons["done"]
    let textFailedPassword = app
      .staticTexts["Senha precisa ser no mínimo 8 palavras, um maiúsculo, um dígito é um especial"]

    textPassword.tap()
    textPassword.typeText("abacate54%") // cuidado # nao e permitido
    doneButton.tap()

    XCTAssertTrue(textFailedPassword.exists)
  }
}

extension SigInScreen_UiTests {
  func findLabelAndReturnElement(_ label: String) -> XCUIElement {
    let predicate = NSPredicate(format: "label == '\(label)'")
    return app.descendants(matching: .any).matching(predicate).firstMatch
  }
}
