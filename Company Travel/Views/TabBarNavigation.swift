//
//  TabBarNavigation.swift
//  Company Travel
//
//  Created by kenjimaeda on 13/09/23.
//

import SwiftUI

enum TabsTag: Int {
  case home = 1
  case favorite = 2
  case profille = 3
}

struct TabBarNavigation: View {
  let handleCurrentTag: (TabsTag) -> Void
  let currentTag: TabsTag

  var body: some View {
    HStack(spacing: 0) {
      ContentButtonTabBar(handlePressButton: { handleCurrentTag(.home) }, viewNavigation: {
        HStack {
          if currentTag == .home {
            Image("homeFilled")
              .resizable()
              .renderingMode(.template) // para colorir precisa dessa propriedade
              .foregroundColor(ColorsApp.blue)
              .frame(width: 30, height: 30)

            Text("Principal")
              .font(.custom(FontsApp.openLight, size: 16))
              .foregroundColor(ColorsApp.blue)
          }
        }
      }, isSelected: currentTag == .home, nameIcon: "house")
      Spacer()
      ContentButtonTabBar(handlePressButton: { handleCurrentTag(.favorite) }, viewNavigation: {
        Group {
          if currentTag == .favorite {
            Image("doubleHeartFilled")
              .resizable()
              .renderingMode(.template)
              .foregroundColor(ColorsApp.blue)
              .frame(width: 30, height: 30)
            Text("Favorito")
              .font(.custom(FontsApp.openLight, size: 16))
              .foregroundColor(ColorsApp.blue)
          }
        }
      }, isSelected: currentTag == .favorite, nameIcon: "doubleHeart")
      Spacer()
      ContentButtonTabBar(handlePressButton: { handleCurrentTag(.profille) }, viewNavigation: {
        Group {
          if currentTag == .profille {
            Image("configFilled")
              .resizable()
              .renderingMode(.template)
              .foregroundColor(ColorsApp.blue)
              .frame(width: 30, height: 30)
            Text("Perfil")
              .font(.custom(FontsApp.openLight, size: 16))
              .foregroundColor(ColorsApp.blue)
          }
        }
      }, isSelected: currentTag == .profille, nameIcon: "config")
    }
    .ignoresSafeArea(.all)
    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 50)
    .background(ColorsApp.white, ignoresSafeAreaEdges: .all)
  }
}
