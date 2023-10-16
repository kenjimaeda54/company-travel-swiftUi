//
//  DetailsDestinationScreen_UiTests.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 10/10/23.
//

import Foundation
import XCTest

final class DetailsDestinationScreen_UiTests: XCTestCase {
  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
    app.launchEnvironment = ["ENV": "TEST", "SCREEN": "LOGIN"]
    app.launch()

    let buttonRegister = app.buttons["Entrar"]

    let textFieldEmail = app.textViews["Insira seu email"]
    let textFieldPassword = app.secureTextFields["Insira uma senha"]
    let predicateRow =
      NSPredicate(format: "identifier CONTAINS 'Quantity favorite 0'")
    let row = app.descendants(matching: .any).matching(predicateRow).firstMatch

    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")
    buttonRegister.tap()
    row.tap()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testScreenRenderedCorrectlyAsNavigated() {
    let title = app.staticTexts["Dallas"]
    let price = app.staticTexts["R$ 2350,70 /pessoa"]
    let predicateOverView = NSPredicate(
      format: "label CONTAINS 'Dallas, uma moderna metrópole no norte do Texas, é um centro comercial e cultural da região. O Sixth Floor Museum na Dealey Plaza, no centro, assinala o local do assassinato do Presidente John F. Kennedy, em 1963. No bairro artístico, o Dallas Museum of Art e o Crow Collection of Asian Art abrangem milhares de anos de arte. O elegante Nasher Sculpture Center exibe esculturas contemporâneas.'"
    )

    let overView = app.descendants(matching: .any).matching(predicateOverView).firstMatch
    let predicatePoster =
      NSPredicate(
        format: "identifier CONTAINS 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=800'"
      )
    let poster = app.descendants(matching: .any).matching(predicatePoster).firstMatch

    XCTAssertTrue(title.exists)
    XCTAssertTrue(poster.exists)
    XCTAssertTrue(price.exists)
    XCTAssertTrue(overView.exists)
  }
}
