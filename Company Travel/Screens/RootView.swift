//
//  RootView.swift
//  Company Travel
//
//  Created by kenjimaeda on 25/09/23.
//

import SwiftUI

struct RootView: View {
  var user: UserModel?
  @StateObject var enviromentUser = EnvironmentUser()

  var body: some View {
    ZStack {
      if user != nil {
        BottomNavigation(currentTag: .home)
          .environmentObject(enviromentUser)
      } else {
        LogIn()
      }
    }
    .onAppear {
      if user != nil {
        enviromentUser.user = user!
      }
    }
  }
}
