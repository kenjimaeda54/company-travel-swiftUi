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
  @StateObject var store = StoreUsers(httpClient: HttpClientFactory.create())

  var body: some View {
    ZStack {
      if user != nil {
        BottomNavigation(currentTag: .home)
      } else {
        LogIn()
      }
    }
    .environmentObject(enviromentUser)
    .onAppear {
      if user != nil {
        enviromentUser.user = user!
      }
    }
  }
}
