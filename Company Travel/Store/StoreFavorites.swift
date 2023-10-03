//
//  StoreFavorites.swift
//  Company Travel
//
//  Created by kenjimaeda on 27/09/23.
//

import Foundation

class StoreFavorites: ObservableObject {
  let httpClient: HttpClientProtocol
  @Published var stateLoading = StateLoading.loading
  @Published var favorites: [FavoriteModel] = []

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
    self.favorites = []
  }

  func getFavoritesByUser(userId: String) {
    httpClient.getFavoritesByUser(idUser: userId) { result in

      switch result {
      case let .success(favorites):

        DispatchQueue.main.async {
          self.stateLoading = StateLoading.sucess
          self.favorites = favorites
        }

      case let .failure(error):

        print(error.localizedDescription)
        DispatchQueue.main.async {
          self.stateLoading = StateLoading.failure
        }
      }
    }
  }

  func addFavorite(favorite: FavoriteModel) {
    httpClient.addFavorite(favorite: favorite)
  }

  func deleteFavorite(documentId: String) {
    httpClient.removeFavorite(documentId: documentId)
  }
}
