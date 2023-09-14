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
  var textFieldValidate: TextFieldValidate?

  var body: some View {
    VStack(alignment: .leading) {
      TextField(
        "",
        text: $value,
        prompt:
        Text(placeHolderText)
          .font(.custom(FontsApp.openLight, size: 17))
          .foregroundColor(ColorsApp.gray),
        axis: .vertical
      )

      .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .font(.custom(FontsApp.openRegular, size: 17))
        .foregroundColor(ColorsApp.gray)
        .background(
          RoundedRectangle(cornerRadius: 5)
            .stroke(ColorsApp.gray.opacity(0.5), lineWidth: 1)
        )

      if textFieldValidate != nil {
        Text(textFieldValidate!.feedBackWrong)
          .foregroundColor(ColorsApp.red)
          .font(.custom(FontsApp.openLight, size: 16))
      }
    }
  }
}

struct TextFieldCommon_Previews: PreviewProvider {
  static var previews: some View {
    TextFieldCommon(value: .constant(""), placeHolderText: "Coloque um email", textFieldValidate: nil)
  }
}
