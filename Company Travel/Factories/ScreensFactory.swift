//
//  ScreensFactory.swift
//  Company Travel
//
//  Created by kenjimaeda on 22/09/23.
//

import Foundation
import SwiftUI

class ScreensFactory {
  static func create() -> some View {
    let argumentsScreen = ProcessInfo.processInfo.environment["SCREEN"]
    let argumentsEnv = ProcessInfo.processInfo.environment["ENV"]

    @ViewBuilder
    var view: some View {
      if argumentsEnv == "TEST" {
        switch argumentsScreen {
        case "HOME":
          HomeScreen()

        case "FAVORITE":
          FavoriteScreen()

        default:
          SigIn()
        }

      } else {
        SigIn()
      }
    }

    return view
  }
}
