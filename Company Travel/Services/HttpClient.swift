//
//  HttpClient.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import Foundation

class HttpClient: HttpClientProtocol {
  static var destination: [DestinationModel] = []
  static let db = Firestore.firestore()
  static let auth = Auth.auth()
  static let storage = Storage.storage()

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

  // como mostrar uma imagem apos o dowloud
  // https://gist.github.com/rphlfc/13cdd3019e4fdae1ca37d34247a185e0
  // https://firebase.google.com/docs/storage/ios/download-files?hl=pt-br
  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (Result<User, HttpError>) -> Void
  ) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print(error.localizedDescription)
        completion(.failure(.badResponse))
      }

      if let user = authResult?.user {
        let storageRef = HttpClient.storage.reference()
        let photoUserRef = storageRef.child("images/\(user.uid).jpg")
        if let uploadPhoto = data {
          photoUserRef.putData(uploadPhoto, metadata: nil) { _, _ in

            photoUserRef.downloadURL { url, _ in
              guard url != nil else {
                return completion(.failure(.badURL))
              }
            }
          }
        }
        completion(.success(user))
      }
    }
  }
}
