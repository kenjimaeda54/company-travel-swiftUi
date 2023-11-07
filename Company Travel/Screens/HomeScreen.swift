//
//  ContentView.swift
//  Company Travel
//
//  Created by kenjimaeda on 10/09/23.
//

import CachedAsyncImage
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct HomeScreen: View {
  @ObservedObject var storeHome = StoreHome(httpClient: HttpClientFactory.create())
  @StateObject private var storeUser = StoreUsers(httpClient: HttpClientFactory.create())
  @ObservedObject var storeFavorite = StoreFavorites(httpClient: HttpClientFactory.create())
  @EnvironmentObject var stateUser: EnvironmentUser
  @State private var isPresentedLogin = false

  func handleSignOut() {
    storeUser.signOut()
    isPresentedLogin = true
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      Group {
        HStack {
          VStack(alignment: .leading) {
            Text("Ola \(stateUser.user.displayName ?? ""), ")
              .font(.custom(FontsApp.openLight, size: 17))
              .foregroundColor(ColorsApp.gray)
            Text("Viajando hoje?")
              .font(.custom(FontsApp.openBold, size: 23))
              .foregroundColor(ColorsApp.black)
          }
          Spacer()
          HStack(alignment: .bottom) {
            AsyncImage(url: stateUser.user.photoUrl ?? URL(string: "https://github.com/kenjimaeda54.png")) { phase in
              if let image = phase.image {
                image
                  .resizable()
                  .frame(width: 50, height: 50)
                  .clipShape(Circle())
                  .accessibilityIdentifier("teste")
              }
            }
            Button(action: { handleSignOut() }) {
              Image(systemName: "power")
                .font(.system(size: 15))
                .foregroundColor(ColorsApp.red)
            }
            .navigationDestination(isPresented: $isPresentedLogin) {
              RootView()
                .navigationBarBackButtonHidden()
            }
          }
        }
        .accessibilityIdentifier(stateUser.user.photoUrl!.absoluteString)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        Text("Destinos")
          .font(.custom(FontsApp.openRegular, size: 20))
          .foregroundColor(ColorsApp.black)
          .frame(maxWidth: .infinity, alignment: .leading)

        if storeHome.stateLoading == .sucess {
          LazyVGrid(columns: gridItemDestinations, spacing: 30) {
            ForEach(storeHome.destinations) { destination in
              NavigationLink {
                DetailsDestinationScreen(destination: destination)
                  .navigationBarBackButtonHidden(true)
                  .environmentObject(stateUser) // precisa passar via link
              } label: {
                RowDestination(destination: destination) {
                  Image(systemName: "heart.fill")
                    .font(.system(size: 25))
                    .foregroundColor(
                      storeFavorite.favorites
                        .contains(where: { $0.idDestination == destination.id }) ? ColorsApp.red : ColorsApp.gray
                        .opacity(0.6)
                    )
                    .background(
                      Circle()
                        .foregroundColor(ColorsApp.background)
                        .frame(width: 60, height: 60)
                    )
                    .offset(x: 70, y: -140)
                    .zIndex(2)
                    .accessibilityLabel("This image have touch")
                    .redactShimmer(condition: storeFavorite.stateLoading == .loading)
                    .onTapGesture {
                      do {
                        let favoriteDictionary = [
                          "id": UUID().uuidString,
                          "idDestination": destination.id,
                          "idUser": stateUser.user.uid
                        ]

                        let favorite = try FavoriteModel(dictionary: favoriteDictionary)
                        let favoriteInListLocal = storeFavorite.favorites
                          .first(where: { $0.idDestination == destination.id })

                        if let favoriteLocal = favoriteInListLocal {
                          storeFavorite.deleteFavorite(documentId: favoriteLocal.id)
                          storeFavorite.favorites.removeAll(where: { $0.id == favoriteLocal.id })

                        } else {
                          storeFavorite
                            .addFavorite(favorite: favorite)

                          return storeFavorite.favorites.append(favorite)
                        }

                      } catch {
                        print(error.localizedDescription)
                      }
                    }
                }
                .accessibilityIdentifier("Quantity favorite \(storeFavorite.favorites.count)")
              }
            }

            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
          }
          .scrollBounceBehavior(.basedOnSize)
          .accessibilityIdentifier("GridHomeDestination")
        }
      }
      .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
    .scrollBounceBehavior(.basedOnSize)
    .onAppear {
      storeHome.getDestinations()
      storeFavorite.getFavoritesByUser(userId: stateUser.user.uid)
    }
    .background(ColorsApp.background, ignoresSafeAreaEdges: .all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeScreen().environmentObject(EnvironmentUser())
  }
}
