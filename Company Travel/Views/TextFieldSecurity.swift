//
//  TextFieldSecurity.swift
//  Company Travel
//
//  Created by kenjimaeda on 16/09/23.
//

import SwiftUI

struct TextFieldSecurity<Content: View>: View {
  var isSecure: Bool
  @Binding var value: String
  let icon: () -> Content
  var action: () -> Void
  var fieldValidate: ValidateTextField?

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        if isSecure {
          SecureField(
            "",
            text: $value.max(15),
            prompt:
            Text("Insira uma senha")
              .font(.custom(FontsApp.openLight, size: 14))
              .foregroundColor(ColorsApp.gray)
          )
          .font(.custom(FontsApp.openRegular, size: 16))
          .autocorrectionDisabled(true)
          .foregroundColor(ColorsApp.black)

          Button(action: action) {
            icon()
              .foregroundColor(ColorsApp.gray)
              .frame(width: 30, height: 30)
          }
        } else {
          TextField(
            "",
            text: $value.max(15),
            prompt: Text("Insira uma senha")
              .font(.custom(FontsApp.openLight, size: 14))
              .foregroundColor(ColorsApp.gray)
          )
          .font(.custom(FontsApp.openRegular, size: 16))
          .autocorrectionDisabled(true)
          .foregroundColor(ColorsApp.black)
          Button(action: action) {
            icon()
              .foregroundColor(ColorsApp.gray)
              .frame(width: 30, height: 30)
          }
        }
      }
      .padding(EdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 15))
      .frame(maxWidth: .infinity)
      .foregroundColor(ColorsApp.black)
      .background(
        RoundedRectangle(cornerRadius: 5)
          .stroke(ColorsApp.black.opacity(0.5), lineWidth: 1)
      )
      if fieldValidate != nil {
        Text(fieldValidate!.feedBackWrong)
          .font(.custom(FontsApp.openLight, size: 12))
          .foregroundColor(ColorsApp.red)
      }
    }
    // maneira mais simples de criar um text field com icone
    // e fazer um hstack e o estilo todo do text field deixo no hstack
    // text field fica sem nenhum estilo visual
  }
}

struct TextFieldSecurity_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldSecurity(isSecure: false, value: .constant(""), icon: {
      Text("ola")
    }, action: {}, fieldValidate: ValidateTextField(feedBackWrong: "Password wrong"))
  }
}
