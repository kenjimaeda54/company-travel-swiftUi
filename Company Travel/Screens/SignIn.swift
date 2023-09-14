//
//  LogInScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 14/09/23.
//

import SwiftUI

struct UserData {
  var name: String
  var password: String
  var email: String
}

struct SigIn: View {
  @State private var user = UserData(name: "", password: "", email: "")
  @State private var iconName = "eye"

  var body: some View {
    Form {
      TextFieldCommon(value: $user.email, placeHolderText: "Coloque seu email")
      TextFieldSecurity(
        value: $user.password,
        iconName: iconName,
        placeHolderText: "Coloque seu  password",
        isSecure: iconName == "eye.slash"
      ) {
        iconName = iconName == "eye" ? "eye.slash" : "eye"
      }
    }
    .formStyle(.columns)
    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
  }
}

struct LogInScreen_Previews: PreviewProvider {
  static var previews: some View {
    SigIn()
  }
}
