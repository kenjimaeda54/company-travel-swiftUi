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
  var token = "lHIoJu5AsQDGn3p4n413z49uQwal"

  init() {
    self.destinations = []
    self.favorites = []
  }

  func generateToken(completion: @escaping (String?) -> Void) {
    guard let url = URL(string: "https://test.api.amadeus.com/v1/security/oauth2/token") else {
      fatalError("Don't exist url")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    // abaixo e uma forma de usar strings, para envair http body no swift
    // se fosse o parametro dicionario seria  igual aqui em JSonSelrilization.data
    // referencia https://github.com/kenjimaeda54/coffes_bar_swiftUi
    // exemplo dicionario params = ["name": "kenji"]

    // em curl seria assim
    // https://www.warp.dev/terminus/curl-post-request#:~:text=cURL%20(curl)%20is%20an%20open,%5Boptions%5D%20%5BURL%5D.
    // curl "https://test.api.amadeus.com/v1/security/oauth2/token" \
    //		-H "Content-Type: application/x-www-form-urlencoded" \
    //	-d "grant_type=client_credentials&client_id=RHE8EXAcKBVbmqtX43SVJAGm1YEmdfcj&client_secret=6YewHmn1sqHeaUV3"
    let params =
      "grant_type=client_credentials&client_id=RHE8EXAcKBVbmqtX43SVJAGm1YEmdfcj&client_secret=6YewHmn1sqHeaUV3"
    let finalBody = params.data(using: .utf8)

    request.httpBody = finalBody

    URLSession.shared.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        fatalError("Don't exit data ")
      }

      do {
        let authentication = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        if let token = authentication?["access_token"] as? String {
          completion(token)
        }

      } catch {
        print(error.localizedDescription)
        completion(nil)
      }
    }.resume()
  }

  func getUserLoged(completion: @escaping (UserModel?) -> Void) {
    auth.addStateDidChangeListener { _, user in
      if let user = user {
        let userModel = UserModel(
          uid: user.uid,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          email: user.email
        )
        completion(userModel)
      }
    }
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
          pointsActivies: it["pointsActives"] as? [Double] ?? [],
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
      guard let user = authResult?.user, error == nil else {
        print(error?.localizedDescription)
        return completion(.failure(.badURL))
      }

      self.converterDataFromUrlRequest(data: data, reference: user.uid) { result in

        switch result {
        case let .success(url):
          let userModel = UserModel(
            uid: user.uid,
            displayName: name,
            photoUrl: url,
            email: user.email
          )
          self.updateUser(name: name, photoUrl: url)
          return completion(.success(userModel))

        case let .failure(error):
          print(error)
        }
      }
    }
  }

  func converterDataFromUrlRequest(
    data: Data?,
    reference: String,
    completion: @escaping (Result<URL, HttpError>) -> Void
  ) {
    let storageRef = storage.reference()
    let photoUserRef = storageRef.child("images/\(reference).jpg")
    if let uploadPhoto = data {
      photoUserRef.putData(uploadPhoto, metadata: nil) { _, error in

        if error != nil {
          print(error)
          return completion(.failure(.badResponse))
        }

        photoUserRef.downloadURL { url, _ in
          if let url = url {
            return completion(.success(url))
          }

          return completion(.failure(.badURL))
        }
      }
    }
    return completion(.failure(.noData))
  }

  func sigIn(email: String, password: String, completion: @escaping (Result<UserModel, HttpError>) -> Void) {
    auth.signIn(withEmail: email, password: password) { authResult, error in

      guard let user = authResult?.user, error == nil else {
        print(error?.localizedDescription)
        return completion(.failure(.badResponse))
      }

      let userModel = UserModel(
        uid: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        email: user.email
      )
      completion(.success(userModel))

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

  func signOut() {
    do {
      try auth.signOut()
    } catch let signOutError as NSError {
      print(signOutError.localizedDescription)
    }
  }

  // verificar se esta entrando em email e password
  func updateUser(name: String, photoUrl: URL, password: String? = nil) {
    let changeRequest = auth.currentUser?.createProfileChangeRequest()
    changeRequest?.displayName = name
    changeRequest?.photoURL = photoUrl
    changeRequest?.commitChanges { error in
      print(error?.localizedDescription)
    }

    if let password = password {
      Auth.auth().currentUser?.updatePassword(to: password) { error in
        print(error?.localizedDescription)
      }
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

  // esta funcionando mas pode mlehroar
  // https://stackoverflow.com/questions/52347576/send-post-request-with-bearer-token-and-json-body-in-swift
  func getPointsInterest(
    geocode: PointsGeoCode,
    completion: @escaping (Result<PointsInterestModel, HttpError>) -> Void

  ) {
    guard let url =
      URL(
        string: "https://test.api.amadeus.com/v1/reference-data/locations/pois?latitude=\(geocode.latitude)&longitude=\(geocode.longitude)&radius=5"
      )
    else {
      return completion(.failure(.badURL))
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in

      guard let data = data, error == nil else {
        return completion(.failure(.badResponse))
      }

      if (response as? HTTPURLResponse)?.statusCode == 200 {
        do {
          let response = try JSONDecoder().decode(PointsInterestModel.self, from: data)
          completion(.success(response))
        } catch {
          print(error.localizedDescription)
        }
      }

      if (response as? HTTPURLResponse)?.statusCode == 401 {
        self.generateToken { token in
          if let token = token {
            self.token = token

            request.setValue("Bearer  \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { newData, _, newError in

              guard let newData = newData, newError == nil else {
                return completion(.failure(.badResponse))
              }

              do {
                let response = try JSONDecoder().decode(PointsInterestModel.self, from: newData)
                return completion(.success(response))
              } catch {
                print(error.localizedDescription)
                return completion(.failure(.noData))
              }

            }.resume()
          }
        }
      }

    }.resume()
  }
}
