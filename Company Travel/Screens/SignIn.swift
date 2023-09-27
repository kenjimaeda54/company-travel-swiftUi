//
//  LogInScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 14/09/23.
//

import SwiftUI

struct UserDataSigIn {
  var name: String
  var email: String
  var password: String
}

enum FocusField: Int, Hashable {
  case name, phone, email, password, none
}

struct SigIn: View {
  @State private var user = UserDataSigIn(name: "", email: "", password: "")
  @State private var showSheetCamera = false
  @State private var showSheetGallery = false
  @State private var showSheetSelectGaleryOrCamera = false
  @State private var image = UIImage()
  @State private var isPresented = false
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
    let isDisabledButton = !validateEmail || !validatePassword || user.name.isEmpty || !image.hasContent
    return isDisabledButton
  }

  var validateTextFieldPassword: ValidateTextField? {
    validatePassword ? nil :
      ValidateTextField(feedBackWrong: "Senha precisa ser no mínimo 8 palavras, um maiúsculo, um dígito é um especial")
  }

  var imageForFirebase: Data? {
    return image.jpegData(compressionQuality: 0.5)
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

  func handleToogleCamera() {
    showSheetSelectGaleryOrCamera.toggle()
  }

  func handleGetPhotoGallery() {
    showSheetSelectGaleryOrCamera = false
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      showSheetGallery.toggle()
    }
  }

  func handleGetPhotoCamera() {
    showSheetSelectGaleryOrCamera = false
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      showSheetCamera.toggle()
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        Button(action: handleToogleCamera) {
          if image.hasContent {
            Image(uiImage: image)
              .resizable()
              .frame(width: 100, height: 100)
              .background(Color.black.opacity(0.2))
              .clipShape(Circle())
          } else {
            Image("avatar")
              .resizable()
              .frame(width: 100, height: 100)
              .background(Color.black.opacity(0.2))
              .clipShape(Circle())
          }
        }
        .accessibilityIdentifier("ButtonAvatar")

        Text("Clique na imagem acima para selecionar uma foto")
          .font(.custom(FontsApp.openLight, size: 13))
          .foregroundColor(ColorsApp.gray)
          .padding(EdgeInsets(top: 5, leading: 0, bottom: 20, trailing: 0))
        Spacer()
        Form {
          TextFieldCommon(
            value: Binding(
              get: { user.name }, set: { newValue, _ in

                if (newValue.lastIndex(of: "\n")) != nil {
                  focusedField = .email
                } else if newValue.count < 18 {
                  user.name = newValue
                }
              }

            ),
            placeHolderText: "Coloque seu nome para identificarmos",
            accebilityLabel: "Name"
          )
          .submitLabel(.next)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
          .focused($focusedField, equals: .name)

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
        }
        .formStyle(.columns)
        Spacer()
        ButtonCommon(action: {
          isLoading.toggle()
          storeUser
            .createUser(
              email: user.email,
              password: user.password,
              name: user.name,
              data: imageForFirebase
            ) { user in

              if user != nil {
                isPresented = true
                isLoading.toggle()
              } else {
                validateFieldEmail = ValidateTextField(feedBackWrong: "Ops! Este email ja foi registrado")
                isLoading.toggle()
              }
            }

        }, title: "Cadastrar", isLoading: isLoading)
          .disabled(isDisabledButton || isLoading)
          .opacity(isDisabledButton ? 0.5 : 1)
      }
      .safeAreaInset(edge: .top, alignment: .leading) {
        BackButton(foregroundColor: ColorsApp.black)
          .frame(width: 15, height: 10)
      }
      .padding(EdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20))
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      .background(ColorsApp.background)
      .sheet(isPresented: $showSheetSelectGaleryOrCamera) {
        VStack(alignment: .leading) {
          if UIDevice.current.isSimulator {
            Text("Identificamos que esta em um emulador 🥲")
              .font(.custom(FontsApp.openLight, size: 16))
              .foregroundColor(ColorsApp.gray)
            ButtonCommon(
              action: handleGetPhotoGallery,
              title: "Pegar foto da galeria"
            )

          } else {
            ButtonCommon(
              action: handleGetPhotoGallery,
              title: "Pegar foto da galeria"
            )
            ButtonCommon(
              action: handleGetPhotoCamera,
              title: "Tirar foto"
            )
          }
        }
        .presentationDetents([.small])
        .presentationBackground(ColorsApp.white)
        .frame(alignment: .center)
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
      }
      .navigationDestination(isPresented: $isPresented) {
        RootView(user: storeUser.user)
          .navigationBarBackButtonHidden(true)
      }
    }
    .sheet(isPresented: $showSheetCamera) {
      ImagePicker(sourceType: .camera, selectedImage: $image)
    }
    .sheet(isPresented: $showSheetGallery) {
      ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        .accessibilityIdentifier("ImagePickerLibrary")
    }
    .accessibilityIdentifier("SheetSelectedPhotoLibrary")
  }
}

struct LogInScreen_Previews: PreviewProvider {
  static var previews: some View {
    SigIn()
  }
}
