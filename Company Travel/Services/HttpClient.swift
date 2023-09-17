//
//  HttpClient.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

class HttpClient: HttpClientProtocol {
  static var destination: [DestinationModel] = []
  static let db = Firestore.firestore()
  static let auth = Auth.auth()

  init() {
    HttpClient.destination = []
  }

  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void) {
    HttpClient.db.collection("Destination").getDocuments { snapshot, error in
      if error != nil {
        return completion(.failure(.badResponse))
      }

      guard let document = snapshot?.documents else {
        return completion(.failure(.noData))
      }

      for it in document {
        let destionation = DestinationModel(
          id: it["id"] as? String ?? "",
          location: it["location"] as? String ?? "",
          overview: it["overview"] as? String ?? "",
          pointsActivies: it["pointsActivies"] as? [Double] ?? [],
          poster: it["poster"] as? String ?? "",
          price: it["price"] as? String ?? "",
          title: it["title"] as? String ?? ""
        )

        HttpClient.destination.append(destionation)
      }
      completion(.success(HttpClient.destination))
    }
  }

  func createUser(email: String, password: String, completion: @escaping (Result<User, HttpError>) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        completion(.failure(.badResponse))
      }

      if let user = authResult?.user {
        completion(.success(user))
      }
    }
  }
}
