//
//  BackButton.swift
//  Company Travel
//
//  Created by kenjimaeda on 26/09/23.
//

import SwiftUI

struct BackButton: View {
  var foregroundColor: Color
  @Environment(\.dismiss) var dismiss

  func handleBack() {
    dismiss()
  }

  var body: some View {
    ZStack {
      Color.clear
      Button(action: handleBack) {
        Image(systemName: "chevron.left")
          .resizable()
          .foregroundColor(ColorsApp.black)
          .aspectRatio(contentMode: .fit)
      }
    }

    // passar um blur quando o fundo e branco
//    .background(
//      .ultraThinMaterial,
//      in: Circle()
//    )
  }
}

struct BackButton_Previews: PreviewProvider {
  static var previews: some View {
    BackButton(foregroundColor: ColorsApp.black)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(ColorsApp.blue)
  }
}
