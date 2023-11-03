//
//  StorePhone.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import FirebaseAuth
import Foundation

class StoreUsers: ObservableObject {
  @Published var user: UserModel?
  @Published var isLoading = StateLoading.waiting
  let httpClient: HttpClientProtocol

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
  }

  func getUserLoged(completion: @escaping (UserModel?) -> Void) {
    httpClient.getUserLoged { user in
      completion(user)
      self.user = user
    }
  }

  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (UserModel?) -> Void
  ) {
    isLoading = StateLoading.loading
    httpClient.createUser(email: email, password: password, name: name, data: data) { result in

      switch result {
      case let .success(user):

        DispatchQueue.main.async {
          self.user = user
          self.isLoading = .sucess
          completion(user)
        }

      case let .failure(error):
        print(error)
        DispatchQueue.main.async {
          self.isLoading = .failure
          completion(nil)
        }
      }
    }
  }

  func logIn(email: String, password: String, completion: @escaping (UserModel?) -> Void) {
    httpClient.sigIn(email: email, password: password) { result in

      switch result {
      case let .success(user):

        DispatchQueue.main.async {
          self.user = user
          completion(user)
        }

      case let .failure(error):
        print(error)
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }

  func updateUser(
    password: String? = nil,
    data: Data? = nil,
    name: String? = nil
  ) {
    httpClient.getUserLoged { currentUser in
      self.httpClient.converterDataFromUrlRequest(data: data, reference: currentUser!.uid) { result in
        switch result {
        case let .success(url):

          self.httpClient.updateUser(
            name: (name ?? currentUser!.displayName)!,
            photoUrl: url,
            password: password
          )

        case .failure:
          self.httpClient.updateUser(
            name: (name ?? currentUser!.displayName)!,
            photoUrl: currentUser!.photoUrl!,
            password: password
          )
        }
      }
    }
  }
}
