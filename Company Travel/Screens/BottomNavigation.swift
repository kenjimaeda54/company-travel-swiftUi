//
//  RootView.swift
//  Company Travel
//
//  Created by kenjimaeda on 13/09/23.
//

import SwiftUI

struct BottomNavigation: View {
  @State var currentTag: TabsTag = .home

  func handleCurrentTag(_ tag: TabsTag) {
    currentTag = tag
  }

  var body: some View {
    NavigationStack {
      switch currentTag {
      case .home:
        HomeScreen()
          .safeAreaInset(edge: .bottom) {
            BottomItemNavigation(handleCurrentTag: handleCurrentTag, currentTag: currentTag)
          }

      case .favorite:
        FavoriteScreen()
          .safeAreaInset(edge: .bottom) {
            BottomItemNavigation(handleCurrentTag: handleCurrentTag, currentTag: currentTag)
          }

      case .profille:
        ProfileScreen()
          .safeAreaInset(edge: .bottom) {
            BottomItemNavigation(handleCurrentTag: handleCurrentTag, currentTag: currentTag)
          }
      }
    }
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    BottomNavigation()
  }
}
