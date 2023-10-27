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
  let httpClient: HttpClientProtocol

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
  }

  func getUserLoged() {
    Auth.auth().addStateDidChangeListener { _, user in
      if let user = user {
        let userModel = UserModel(
          uid: user.uid,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          email: user.email
        )
        self.user = userModel
      }
    }
  }

  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (UserModel?) -> Void
  ) {
    httpClient.createUser(email: email, password: password, name: name, data: data) { result in

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

  func updateUser(email: String? = nil, password: String? = nil, data: Data? = nil, name: String? = nil) {
    getUserLoged()

    httpClient.converterDataFromUrlRequest(data: data, reference: user!.uid) { result in

      switch result {
      case let .success(url):
        self.httpClient.updateUser(
          name: name ?? self.user!.displayName!,
          photoUrl: url,
          email: email,
          password: password
        )

      case let .failure(error):

        print(error)
      }
    }
  }
}
