//
//  HomeStoreModel.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation

class StoreHome: ObservableObject {
  let httpClient: HttpClientProtocol
  @Published var stateLoading = StateLoading.loading
  var destinations: [DestinationModel] = []

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
  }

  func getDestinations() {
    httpClient.fetchDestination { result in

      switch result {
      case let .failure(error):
        print(error)

        DispatchQueue.main.async {
          self.stateLoading = .failure
        }

      case let .success(data):

        DispatchQueue.main.async {
          self.stateLoading = .sucess
          self.destinations = data
        }
      }
    }
  }
}
