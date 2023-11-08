//
//  HomeScreen_Tests.swift
//  Company Travel_Tests
//
//  Created by kenjimaeda on 20/09/23.
//

@testable import Company_Travel
import XCTest

final class HomeScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()

    let buttonRegister = app.buttons["Entrar"]

    let textFieldEmail = app.textViews["Insira seu email"]
    let textFieldPassword = app.secureTextFields["Insira uma senha"]

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")
    buttonRegister.tap()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testExistsGridDestionationAndCorrectRenderItens() {
    let grid = app.otherElements["GridHomeDestination"]
    XCTAssertTrue(grid.waitForExistence(timeout: 5))

    let predicate =
      NSPredicate(format: "label CONTAINS 'This image have touch'") // uma possibilidade e adicionar accessibilityLabel
    // na view
    let gridItems = grid.images.containing(predicate)
    XCTAssertEqual(gridItems.count, 3)

    let texasText = app.staticTexts["Texas, E.U.A"]
    let newYorkText = app.staticTexts["New York, E.U.A"]
    let kamatakaText = app.staticTexts["Kamataka, India"]

    XCTAssertTrue(texasText.exists)
    XCTAssertTrue(newYorkText.exists)
    XCTAssertTrue(kamatakaText.exists)
  }

  func testRenderCorrectNameAndImageUser() {
    let nameText = app.staticTexts["Ola Maeda, "]
    let predicateImageAvatar = NSPredicate(format: "identifier == 'https://github.com/kenjimaeda54.png'")
    let image = app.descendants(matching: .any).matching(predicateImageAvatar).firstMatch

    XCTAssertTrue(image.exists)

    XCTAssertTrue(nameText.exists)
  }

  func testAddAndRemoveFavorites() {
    let grid = app.otherElements["GridHomeDestination"]
    let predicateRow =
      NSPredicate(format: "identifier CONTAINS 'Quantity favorite 0'") // injetei na arvore com identifier a quantidade
    // de favoritos
    let row = app.descendants(matching: .any).matching(predicateRow).firstMatch
    XCTAssertTrue(grid.waitForExistence(timeout: 5))
    XCTAssertTrue(row.exists)

    let predicateImage =
      NSPredicate(format: "label CONTAINS 'This image have touch'")
    let imagem = grid.images.containing(predicateImage).firstMatch
    imagem.tap()

    XCTAssertFalse(row.exists) // aqui tera ja adicionado um

    imagem.tap() // depois que clicar tenho que garantir que removeu

    XCTAssertTrue(row.exists)
  }
}
