//
//  ButtonTabBar.swift
//  Company Travel
//
//  Created by kenjimaeda on 13/09/23.
//

import SwiftUI

struct ContentButtonTabBar<LabelNavigation: View>: View {
  let handlePressButton: () -> Void
  var viewNavigation: () -> LabelNavigation
  var isSelected: Bool
  var nameIcon: String

  var body: some View {
    Button(action: handlePressButton) {
      if isSelected {
        viewNavigation()
      } else {
        HStack {
          Image(nameIcon)
            .resizable()
            .frame(width: 30, height: 30)
        }
      }
    }
    .padding(EdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25))
  }
}

struct ButtonTabBar_Previews: PreviewProvider {
  static var previews: some View {
    ContentButtonTabBar(handlePressButton: {}, viewNavigation: {
      Text("Home")
        .font(.custom(FontsApp.openLight, size: 16))
        .foregroundColor(ColorsApp.blue)
    }, isSelected: false, nameIcon: "doubleHeart")
  }
}
