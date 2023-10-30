//
//  ProfileScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 12/09/23.
//

import AlertToast
import CachedAsyncImage
import SwiftUI

enum FieldFocus: Int, Hashable {
  case email
  case password
  case displayName
  case none
}

struct ProfileScreen: View {
  @State private var image = UIImage()
  @StateObject private var storeUser = StoreUsers(httpClient: HttpClientFactory.create())
  @EnvironmentObject var enviromentUser: EnvironmentUser
  @State private var showSheetCamera = false
  @State private var showSheetGallery = false
  @FocusState private var fiedlFocus: FieldFocus?
  @State private var showSheetSelectGaleryOrCamera = false
  @State private var isLoading = false
  @State private var displayName = ""
  @State private var showMessageUpdateUser = false
  @State private var email = ""
  @State private var password = ""
  var imageFirebase: Data? {
    return image.jpegData(compressionQuality: 0.5)
  }

  var validateEmail: Bool {
    let pattern =
      "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    return returnIsValiteField(value: email, pattern: pattern)
  }

  // https://stackoverflow.com/questions/39284607/how-to-implement-a-regex-for-password-validation-in-swift
  // regex password
  var validatePassword: Bool {
    let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    return returnIsValiteField(value: password, pattern: pattern)
  }

  func handleUpdate() {
    isLoading = true
    storeUser.updateUser(
      password: validatePassword ? password : nil,
      data: imageFirebase,
      name: displayName.count > 3 ? displayName : nil
    )
    fiedlFocus = Optional.none
    isLoading = false
    showMessageUpdateUser = true
  }

  func handleToogleCamera() {
    showSheetSelectGaleryOrCamera.toggle()
  }

  func handleGetPhotoCamera() {
    showSheetSelectGaleryOrCamera = false
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      showSheetCamera.toggle()
    }
  }

  func handleGetPhotoGallery() {
    showSheetSelectGaleryOrCamera = false
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
      showSheetGallery.toggle()
    }
  }

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Button(action: handleToogleCamera) {
        if image.hasContent {
          Image(uiImage: image)
            .resizable()
            .frame(width: 100, height: 100)
            .background(Color.black.opacity(0.2))
            .clipShape(Circle())
        } else {
          AsyncImage(
            url: enviromentUser.user
              .photoUrl ?? URL(string: "https://github.com/kenjimaeda54.png")
          ) { phase in

            if let image = phase.image {
              image
                .resizable()
                .frame(width: 100, height: 100)
                .background(Color.black.opacity(0.2))
                .clipShape(Circle())
            }
          }
        }
      }
      Spacer(minLength: 100)
      GeometryReader { geo in
        VStack(alignment: .leading, spacing: 10) {
          RowTitleAndSubtitle(
            title: "Nome:",
            subTitle: enviromentUser.user.displayName ?? "",
            valueSubTitle: $displayName,
            spaceAvaibleText: geo.size.width * 0.6
          )
          .focused($fiedlFocus, equals: .displayName)
          RowTitleAndSubtitle(
            title: "Senha:",
            subTitle: "........",
            valueSubTitle: $password,
            spaceAvaibleText: geo.size.width * 0.6
          )
          .focused($fiedlFocus, equals: .password)
          Text(
            !validatePassword && password
              .count > 3 ? "Senha precisa ser no mínimo 8 palavras, um maiúsculo, um dígito é um especial" : ""
          )
          .font(.custom(FontsApp.openLight, size: 12))
          .foregroundColor(ColorsApp.red)
        }
      }

      Spacer()
      ButtonCommon(action: {
        handleUpdate()
      }, title: "Atualizar", isLoading: isLoading)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, 15)
    .padding(.horizontal, 20)
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
    .onDisappear {
      storeUser.getUserLoged { user in
        if let user = user {
          enviromentUser.user = user
        }
      }
    }
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
    .sheet(isPresented: $showSheetCamera) {
      ImagePicker(sourceType: .camera, selectedImage: $image)
    }
    .sheet(isPresented: $showSheetGallery) {
      ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        .accessibilityIdentifier("ImagePickerLibrary")
    }
    .environmentObject(enviromentUser)
    .toast(isPresenting: $showMessageUpdateUser, duration: 2, alert: {
      AlertToast(
        displayMode: .banner(.pop),
        type: .regular,
        title: "Atualizado com sucesso",
        style:
        AlertToast.AlertStyle.style(
          backgroundColor: ColorsApp.blue,
          titleColor: ColorsApp.white,
          titleFont: Font.custom(FontsApp.openRegular, size: 15)
        )
      )
    }) {
      showMessageUpdateUser = false
    }
  }
}

struct ProfileScreen_Previews: PreviewProvider {
  static var previews: some View {
    ProfileScreen().environmentObject(EnvironmentUser())
  }
}
