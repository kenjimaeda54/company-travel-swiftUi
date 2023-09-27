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
    email: String, password: String, name: String, data: Data?,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  ) {
    HttpClient.auth.createUser(withEmail: email, password: password) { authResult, error in
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

              self.sigIn(email: email, password: password) { result in

                switch result {
                case .failure:
                  completion(.failure(.badResponse))

                case .success:
                  self.updateUser(name: name, photoUrl: url!)

                  let userModel = UserModel(
                    uid: user.uid,
                    displayName: name,
                    photoUrl: url!,
                    email: email
                  )
                  completion(.success(userModel))
                }
              }
            }
          }
        }
      }
    }
  }

  func sigIn(email: String, password: String, completion: @escaping (Result<UserModel, HttpError>) -> Void) {
    HttpClient.auth.signIn(withEmail: email, password: password) { authResult, error in

      if let error = error as NSError? {
        print(error.code)
        completion(.failure(.errorEmailorPasswordWrong))
      }

      if let user = authResult?.user {
        let userModel = UserModel(
          uid: user.uid,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          email: user.email
        )
        completion(.success(userModel))
      }

      // uso de .some e where
      //			case let .some(error as NSError)
      //				where error.code == AuthErrorCode.wrongPassword.rawValue:
      //				print("Passwrod wrong")
      //				completion(.failure(.errorEmailorPasswordWrong))
      //
      //			case let .some(error as NSError)
      //				where error.code == AuthErrorCode.invalidEmail.rawValue:
      //				print("Passwrod wrong")
      //				completion(.failure(.errorEmailorPasswordWrong))
      //
      //			case let .some(error as NSError):
      //				print(error.code)
      //				completion(.failure(.badResponse))
      //
      //			case .none:
      //
      //			}
    }
  }

  func updateUser(name: String, photoUrl: URL) {
    let changeRequest = HttpClient.auth.currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = name
    changeRequest?.photoURL = photoUrl
    changeRequest?.commitChanges { error in
      print(error?.localizedDescription)
    }
  }
}
