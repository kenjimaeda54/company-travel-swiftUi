//
//  ScreensFactory.swift
//  Company Travel
//
//  Created by kenjimaeda on 22/09/23.
//

import Foundation
import SwiftUI

class ScreensFactory {
  @ViewBuilder
  static func create() -> some View {
    let argumentsScreen = ProcessInfo.processInfo.environment["SCREEN"]
    let argumentsEnv = ProcessInfo.processInfo.environment["ENV"]

    if argumentsEnv == "TEST" {
      switch argumentsScreen {
      case "HOME":
        HomeScreen()

      case "FAVORITE":
        FavoriteScreen()

      case "SIGIN":
        SigIn()

      default:
        LogIn()
      }

    } else {
      RootView()
    }
  }
}
