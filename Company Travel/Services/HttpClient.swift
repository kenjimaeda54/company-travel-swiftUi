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
  var destinations: [DestinationModel] = []
  var favorites: [FavoriteModel] = []
  let db = Firestore.firestore()
  let auth = Auth.auth()
  let storage = Storage.storage()

  init() {
    self.destinations = []
    self.favorites = []
  }

  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void) {
    destinations = []
    db.collection("Destination").getDocuments { snapshot, error in
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

        self.destinations.append(destionation)
      }
      completion(.success(self.destinations))
    }
  }

  // como mostrar uma imagem apos o dowloud
  // https://gist.github.com/rphlfc/13cdd3019e4fdae1ca37d34247a185e0
  // https://firebase.google.com/docs/storage/ios/download-files?hl=pt-br
  func createUser(
    email: String, password: String, name: String, data: Data?,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  ) {
    auth.createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print(error.localizedDescription)
        completion(.failure(.badResponse))
      }

      if let user = authResult?.user {
        let storageRef = self.storage.reference()
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
    auth.signIn(withEmail: email, password: password) { authResult, error in

      if let error = error as NSError? {
        print(error.code)
        return completion(.failure(.errorEmailorPasswordWrong))
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
    let changeRequest = auth.currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = name
    changeRequest?.photoURL = photoUrl
    changeRequest?.commitChanges { error in
      print(error?.localizedDescription)
    }
  }

  // usando string para struct
  // https://stackoverflow.com/questions/42550657/writing-json-file-programmatically-swift
  func getFavoritesByUser(idUser: String, completion: @escaping (Result<[FavoriteModel], HttpError>) -> Void) {
    favorites = []
    db.collection("Favorites").whereField("idUser", isEqualTo: idUser).getDocuments { querySnapshot, error in

      if error != nil {
        return completion(.failure(.badResponse))
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()
          // se eu fizer o foreach ou map estarei desmembro cada data, ou seja esse document.data() representa
          // o data de um documento, e assim por diante //["idUser": vWOQlzYKdSaDBxqDt6NA3JdV1rD2, "idDestionation":
          // 56778dsdewewewszas]

          do {
            let favoriteDictionary = [
              "id": document.documentID,
              "idUser": data["idUser"],
              "idDestination": data["idDestination"]
            ]

            let favorite = try FavoriteModel(dictionary: favoriteDictionary)
            self.favorites.append(favorite)
          } catch {
            print(error.localizedDescription)
          }
        }
        completion(.success(self.favorites))
      }
    }
  }

  func addFavorite(favorite: FavoriteModel) {
    db.collection("Favorites").document(favorite.id).setData([
      "idDestination": favorite.idDestination,
      "idUser": favorite.idUser
    ]) { error in

      if let error = error {
        return print(error)
      }
    }
  }

  func removeFavorite(documentId: String) {
    db.collection("Favorites").document(documentId).delete { error in

      if let error = error {
        print(error.localizedDescription)
      }
    }
  }

  // https://stackoverflow.com/questions/52347576/send-post-request-with-bearer-token-and-json-body-in-swift
  func getPointsInterest(geocode: PointsGeoCode, completion: @escaping (Result<PointsInterest, HttpError>) -> Void) {
    guard let url =
      URL(
        string: "https://test.api.amadeus.com/v1/shopping/activities?latitude=\(geocode.latitude)&longitude=\(geocode.longitude)&radius=15"
      )
    else {
      return completion(.failure(.badURL))
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \("ZAIYqN6xrgvDixLIqULW2CAmPoRT")", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        return completion(.failure(.badResponse))
      }

      do {
        let pointsJson = try JSONDecoder().decode(PointsInterest.self, from: data)
        completion(.success(pointsJson))
      } catch {
        print(error.localizedDescription)
        completion(.failure(.noData))
      }
    }
  }
}
