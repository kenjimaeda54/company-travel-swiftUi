//
//  TextFieldCommonWithIcon.swift
//  Company Travel
//
//  Created by kenjimaeda on 14/09/23.
//

import SwiftUI

struct TextFieldSecurity: View {
  @Binding var value: String
  var iconName: String
  var placeHolderText: String
  var isSecure: Bool
  var handleClickIcon: () -> Void

  // segredo e fazer hstack e todo estilo do input fica no hstack nao no input
  // input deixa puro
  var body: some View {
    HStack {
      if isSecure {
        SecureField(
          "",
          text: $value.max(15),
          prompt:
          Text(placeHolderText)
            .font(.custom(FontsApp.openLight, size: 17))
            .foregroundColor(ColorsApp.gray)
        )
        Button(action: handleClickIcon) {
          Image(systemName: iconName)
            .font(.system(size: 20))
            .foregroundColor(ColorsApp.gray)
        }

      } else {
        TextField(
          "",
          text: $value.max(15),
          prompt:
          Text(placeHolderText)
            .font(.custom(FontsApp.openLight, size: 17))
            .foregroundColor(ColorsApp.gray),
          axis: .vertical
        )
        Button(action: handleClickIcon) {
          Image(systemName: iconName)
            .font(.system(size: 20))
            .foregroundColor(ColorsApp.gray)
        }
      }
    }
    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
    .font(.custom(FontsApp.openRegular, size: 17))
    .foregroundColor(ColorsApp.gray)
    .background(
      RoundedRectangle(cornerRadius: 5)
        .stroke(ColorsApp.gray.opacity(0.5), lineWidth: 1)
    )
  }
}

struct TextFieldCommonWithIcon_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldSecurity(
      value: .constant(""),
      iconName: "eye",
      placeHolderText: "Coloque email",
      isSecure: true,
      handleClickIcon: {}
    )
  }
}
