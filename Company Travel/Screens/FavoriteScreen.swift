//
//  FavoriteScreen.swift
//  Company Travel
//
//  Created by kenjimaeda on 12/09/23.
//

import SwiftUI

// ciclos de vida do switui https://medium.com/@Ariobarxan/swiftui-app-life-cycle-e3cac78da47
struct FavoriteScreen: View {
  @StateObject private var storeHome = StoreHome(httpClient: HttpClientFactory.create())
  @EnvironmentObject private var environmentUser: EnvironmentUser
  @StateObject private var storeFavorite = StoreFavorites(httpClient: HttpClientFactory.create())
  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        LazyVGrid(columns: gridItemDestinations) {
          ForEach(storeFavorite.favoritesDestination) { favorites in
            NavigationLink {
              DetailsDestinationScreen(destination: favorites.destination)
                .navigationBarBackButtonHidden(true)
            } label: {
              RowDestination(destination: favorites.destination) {
                Text("")
              }
              .padding(.vertical, 15)
            }
          }
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
      .onAppear {
        storeHome.getDestinations()
        storeFavorite.getFavoritesByUser(userId: environmentUser.user.uid)
      }
      // onReceive e disparado quando publisher for publicado
      // por exempolo quando eu uso o getDestination no onApper e preciso que ao alterar
      // a quantidade de detiono filtro os repectivos favorites
      .onReceive(storeHome.$destinations) { destination in
        storeFavorite.handleDestinationFavorites(destinations: destination)
      }
    }
  }
}

struct FavoriteScreen_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteScreen().environmentObject(EnvironmentUser())
      .environmentObject(StoreHome(httpClient: HttpClientFactory.create()))
      .environmentObject(StoreFavorites(httpClient: HttpClientFactory.create()))
  }
}
