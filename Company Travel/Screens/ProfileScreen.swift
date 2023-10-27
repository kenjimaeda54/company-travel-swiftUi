//
//  ProfileScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 12/09/23.
//

import CachedAsyncImage
import SwiftUI

struct ProfileScreen: View {
  @State private var image = UIImage()
  @StateObject private var storeUser = StoreUsers(httpClient: HttpClientFactory.create())
  @State private var displayName = ""
  @State private var email = ""
  @State private var password = ""
  var imageFirebase: Data? {
    return image.jpegData(compressionQuality: 0.5)
  }

  func handleUpdate() {
    storeUser.updateUser(email: email, password: password, data: imageFirebase, name: displayName)
  }

  var body: some View {
    VStack {
      if image.hasContent {
        Image(uiImage: image)
          .resizable()
          .frame(width: 100, height: 100)
          .background(Color.black.opacity(0.2))
          .clipShape(Circle())
      } else {
        AsyncImage(
          url: storeUser.user?
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
      Spacer()
      RowTitleAndSubtitle(title: "Nome:", subTitle: storeUser.user?.displayName ?? "", valueSubTitle: $displayName)
      RowTitleAndSubtitle(title: "Email:", subTitle: storeUser.user?.email ?? "", valueSubTitle: $email)
      RowTitleAndSubtitle(title: "Senha:", subTitle: "........", valueSubTitle: $password)
      Spacer()
      ButtonCommon(action: {
        handleUpdate()
      }, title: "Atualizar")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, 15)
    .padding(.horizontal, 20)
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
    .onAppear {
      storeUser.getUserLoged()
    }
  }
}

struct ProfileScreen_Previews: PreviewProvider {
  static var previews: some View {
    ProfileScreen()
  }
}
