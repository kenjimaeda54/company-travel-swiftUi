//
//  BackButton.swift
//  Company Travel
//
//  Created by kenjimaeda on 26/09/23.
//

import SwiftUI

struct ButtonCommonWithIcon: View {
  var foregroundColor: Color
  var iconSytem: String
  var action: () -> Void

  var body: some View {
    ZStack {
      Color.clear
      Button(action: action) {
        Image(systemName: iconSytem)
          .resizable()
          .foregroundColor(foregroundColor)
          .aspectRatio(contentMode: .fit)
      }
    }
  }
}

struct BackButton_Previews: PreviewProvider {
  static var previews: some View {
    ButtonCommonWithIcon(foregroundColor: ColorsApp.black, iconSytem: "chrevron-left", action: {})
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(ColorsApp.blue)
  }
}
