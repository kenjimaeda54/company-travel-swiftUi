//
//  LogIn.swift
//  Company Travel
//
//  Created by kenjimaeda on 26/09/23.
//

import SwiftUI

struct UserDataLogIn {
  var email: String
  var password: String
}

struct LogIn: View {
  @State private var user = UserDataLogIn(email: "", password: "")
  @State private var isPresentedSigIn = false
  @State private var isPresentedRoot = false
  @State private var isSecure = true
  @FocusState var focusedField: FocusField?
  @State private var storeUser = StoreUsers(httpClient: HttpClientFactory.create())
  @State private var validateFieldEmail: ValidateTextField?
  @State private var isLoading = false

  var validateEmail: Bool {
    let pattern =
      "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    return returnIsValiteField(value: user.email, pattern: pattern)
  }

  // https://stackoverflow.com/questions/39284607/how-to-implement-a-regex-for-password-validation-in-swift
  // regex password
  var validatePassword: Bool {
    let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    return returnIsValiteField(value: user.password, pattern: pattern)
  }

  var isDisabledButton: Bool {
    let isDisabledButton = !validateEmail || !validatePassword
    return isDisabledButton
  }

  var validateTextFieldPassword: ValidateTextField? {
    validatePassword ? nil :
      ValidateTextField(feedBackWrong: "Senha precisa ser no mínimo 8 palavras, um maiúsculo, um dígito é um especial")
  }

  func handleActionIcon() {
    isSecure.toggle()
  }

  func validateAllConditionsEmail(_ value: String) {
    if value.count > 4 && !validateEmail {
      validateFieldEmail = ValidateTextField(feedBackWrong: "Precisa ser um email valido")
    } else {
      validateFieldEmail = nil
    }
  }

  func handleNavigation() {
    isPresentedSigIn.toggle()
  }

  var body: some View {
    NavigationStack {
      VStack(spacing: 15) {
        Text("Qual é sua próxima viagem?")
          .font(.custom(FontsApp.pacifico, size: 25))
          .foregroundColor(ColorsApp.blue)
        Spacer()
        TextFieldCommon(
          value: Binding(
            get: { user.email }, set: { newValue, _ in

              if (newValue.lastIndex(of: "\n")) != nil {
                focusedField = .password
              } else if newValue.count < 40 {
                user.email = newValue
              }
            }

          ),
          placeHolderText: "Insira seu email",
          fieldValidate: validateFieldEmail,
          accebilityLabel: "Email"
        )
        .onChange(of: user.email, perform: { newValue in
          validateAllConditionsEmail(newValue)
        })
        .lineLimit(3)
        .submitLabel(.next)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        .focused($focusedField, equals: .email)

        TextFieldSecurity(
          isSecure: isSecure,
          value: Binding(
            get: { user.password }, set: { newValue, _ in

              if (newValue.lastIndex(of: "\n")) != nil {
                focusedField = Optional.none
              } else {
                user.password = newValue
              }
            }
          ),
          icon: {
            isSecure ? Image(systemName: "eye.slash") : Image(systemName: "eye")
          },
          action: handleActionIcon,
          fieldValidate: user.password.count > 4 ? validateTextFieldPassword : nil,
          accebilityLabel: "Password"
        )
        .submitLabel(.done)
        .focused($focusedField, equals: .password)

        Spacer()
        ButtonCommon(action: {
          isLoading.toggle()
          storeUser.logIn(email: user.email, password: user.password) { user in

            if user != nil {
              isPresentedRoot.toggle()
              isLoading.toggle()
            } else {
              validateFieldEmail =
                ValidateTextField(
                  feedBackWrong: "Tem certeza que possui registro e sua senha ou e-mail estão corretos?"
                )
              isLoading.toggle()
            }
          }

        }, title: "Entrar", isLoading: isLoading)
          .disabled(isDisabledButton || isLoading)
          .opacity(isDisabledButton ? 0.5 : 1)
          .navigationDestination(isPresented: $isPresentedRoot) {
            RootView(user: storeUser.user)
              .navigationBarBackButtonHidden(true)
          }
        Button(action: handleNavigation) {
          Text("Não possui conta, clique aqui e registre")
            .font(.custom(FontsApp.openLight, size: 15))
            .foregroundColor(ColorsApp.blue)
        }
        .navigationDestination(isPresented: $isPresentedSigIn) {
          SigIn()
            .navigationBarBackButtonHidden(true)
        }
      }
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20))
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .background(ColorsApp.background)
    }
  }
}

struct LogIn_Previews: PreviewProvider {
  static var previews: some View {
    LogIn()
  }
}
