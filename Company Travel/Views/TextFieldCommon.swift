//
//  TextFieldCommon.swift
//  Company Travel
//
//  Created by kenjimaeda on 14/09/23.
//

import SwiftUI

struct TextFieldCommon: View {
  @Binding var value: String
  var placeHolderText: String
  var fieldValidate: ValidateTextField?

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      TextField(
        "",
        text: $value,
        prompt:
        Text(placeHolderText)
          .font(.custom(FontsApp.openLight, size: 14))
          .foregroundColor(ColorsApp.gray),
        axis: .vertical
      )
      .padding(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
      .font(.custom(FontsApp.openRegular, size: 16))
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
  }
}

struct TextFieldCommon_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldCommon(
      value: .constant(""),
      placeHolderText: "Coloque um email",
      fieldValidate: ValidateTextField(feedBackWrong: "email wrong")
    )
  }
}
