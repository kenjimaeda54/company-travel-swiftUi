//
//  HeaderStack.swift
//  Company Travel
//
//  Created by kenjimaeda on 19/10/23.
//

import SwiftUI

struct HeaderStack: View {
  let actionFavorite: () -> Void
  @Environment(\.dismiss) private var dimiss

  func handleBack() {
    dimiss()
  }

  var body: some View {
    HStack {
      ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "chevron.left", action: handleBack)
        .frame(width: 15, height: 10)
        .padding(.all, 7)
        .background(
          .ultraThinMaterial,
          in: Circle()
        )
        .offset(x: 20)
      Spacer()
      ButtonCommonWithIcon(foregroundColor: ColorsApp.white, iconSytem: "heart", action: actionFavorite)
        .frame(width: 15, height: 10)
        .padding(.all, 7)
        .background(
          .ultraThinMaterial,
          in: Circle()
        )
        .offset(x: -20)
    }
  }
}

#Preview {
  HeaderStack(actionFavorite: {})
}
