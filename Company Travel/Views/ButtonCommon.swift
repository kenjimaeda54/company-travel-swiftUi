//
//  ButtomCommon.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import SwiftUI

struct ButtonCommon: View {
  let action: () -> Void
  let title: String
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.custom(FontsApp.openRegular, size: 17))
        .foregroundColor(ColorsApp.white)
        .frame(maxWidth: .infinity)
    }
    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(ColorsApp.blue)
    )
  }
}

struct ButtomCommon_Previews: PreviewProvider {
  static var previews: some View {
    ButtonCommon(action: {}, title: "Prosseguir")
  }
}
