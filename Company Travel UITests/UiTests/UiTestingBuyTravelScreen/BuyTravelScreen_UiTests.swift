//
//  BuyTravelScreen_UiTests.swift
//  Company Travel UITests
//
//  Created by kenjimaeda on 30/10/23.
//

import Foundation
import XCTest

final class BuyTravelScreeen_UiTests: XCTestCase {
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
    let buttonBuy = app.buttons["Comprar agora"]
    textFieldEmail.tap()
    textFieldEmail.typeText("kenji@gmail.com")

    XCTAssertEqual(buttonRegister.isEnabled, false)

    textFieldPassword.tap()
    textFieldPassword.typeText("Abacate54@")
    buttonRegister.tap()
    row.tap()
    buttonBuy.tap()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testRenderTitleCorrectUserBuyTravel() {
    let travel = app
      .staticTexts[
        "Muito obrigado por comprar a viagem para destino Dallas, você recebera por e-mail detalhes sobre pagamento, é da viagem."
      ]
    XCTAssertTrue(travel.exists)
  }

  func testButtonBackApp() {
    let back = app.buttons["Voltar usar App"]
    let travel = app
      .staticTexts[
        "Muito obrigado por comprar a viagem para destino Dallas, você recebera por e-mail detalhes sobre pagamento, é da viagem."
      ]
    back.tap()
    XCTAssertFalse(travel.exists)
  }
}
