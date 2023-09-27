//
//  ContentView.swift
//  Company Travel
//
//  Created by kenjimaeda on 10/09/23.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

// MARK: - Precisamos implementar apos os tests a foto do usuario e o nome conforme faz o create user

struct HomeScreen: View {
  @StateObject var storeHome = StoreHome(httpClient: HttpClientFactory.create())
  @State private var isFavorite = false
  @EnvironmentObject var stateUser: EnvironmentUser
  @State private var user = UserModel(
    uid: "",
    displayName: "",
    photoUrl: URL(string: "https://github.com/kenjimaeda54.png")!,
    email: ""
  )

  var body: some View {
    ScrollView(showsIndicators: false) {
      Group {
        HStack {
          VStack(alignment: .leading) {
            Text("Ola \(user.displayName ?? ""), ")
              .font(.custom(FontsApp.openLight, size: 17))
              .foregroundColor(ColorsApp.gray)
            Text("Viajando hoje?")
              .font(.custom(FontsApp.openBold, size: 23))
              .foregroundColor(ColorsApp.black)
          }
          Spacer()
          AsyncImage(url: user.photoUrl ?? URL(string: "https://github.com/kenjimaeda54.png")) { phase in
            if let image = phase.image {
              image
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
          }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        Text("Destinos")
          .font(.custom(FontsApp.openRegular, size: 20))
          .foregroundColor(ColorsApp.black)
          .frame(maxWidth: .infinity, alignment: .leading)

        if storeHome.stateLoading == .sucess {
          LazyVGrid(columns: gridItemDestionation, spacing: 30) {
            ForEach(storeHome.destinations) { destination in
              RowDestination(destionation: destination, isFavorite: $isFavorite)
            }

            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
          }
          .accessibilityIdentifier("GridHomeDestination")
        }
      }
      .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
    .onAppear {
      storeHome.getDestionations()
      user = stateUser.user
    }
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen().environmentObject(EnvironmentUser())
  }
}
