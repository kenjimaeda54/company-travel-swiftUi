//
//  MockHttpClient.swift
//  Company Travel_Tests
//
//  Created by kenjimaeda on 20/09/23.
//

import FirebaseAuth
import Foundation

// para verificar se o pacote esta no target que preciso no caso o FirebaseAuth tem que esta no
// Company Travel e tambem Tests
// voce vai no target do test e vai em Build Phases -> Link With Libraries

class MockHttpClient: HttpClientProtocol, Mockable {
  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void) {
    let response = loadJson(filename: "Destination", type: [DestinationModel].self)
    completion(.success(response))
  }

  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  ) {
    let users = loadFileManager(filename: "User.json", type: [UserModel].self)
    let findUser = users.first { $0.email == email }
    let userModel = UserModel(uid: "fsfsfsfsl343skfsm", displayName: name, email: email)
    if findUser != nil {
      completion(.failure(.errorCreateUser))
    } else {
      writeFileManager(filename: "User.json", model: userModel)
      completion(.success(userModel))
    }
  }

  func sigIn(
    email: String,
    password: String,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  ) {
    let users = loadFileManager(filename: "User.json", type: [UserModel].self)
    let findUser = users.first { $0.email == email }

    if findUser != nil && password == "Abacate54@" {
      return completion(.success(findUser!))
    }

    completion(.failure(.badResponse))
  }

  func getUserLoged(completion: @escaping (UserModel?) -> Void) {
    let users = loadFileManager(filename: "User.json", type: [UserModel].self)
    let findUser = users.first { $0.uid == "3434342JAJApEDRO" }
    completion(findUser)
  }

  func getFavoritesByUser(idUser: String, completion: @escaping (Result<[FavoriteModel], HttpError>) -> Void) {
    completion(.failure(.badResponse))
  }

  func signOut() {
    print("remove user")
  }

  func addFavorite(favorite: FavoriteModel) {}

  func removeFavorite(documentId: String) {}

  func getPointsInterest(
    geocode: PointsGeoCode,
    completion: @escaping (Result<PointsInterestModel, HttpError>) -> Void
  ) {
    let pointsInterest = loadJson(filename: "PointsInterest", type: PointsInterestModel.self)
    completion(.success(pointsInterest))
  }

  func converterDataFromUrlRequest(
    data: Data?,
    reference: String,
    completion: @escaping (Result<URL, HttpError>) -> Void
  ) {
    completion(.failure(.badURL))
  }

  // user precisa estar fora do bundle local pra conseguir atualizar
  // depois tentar isso
  // https://stackoverflow.com/questions/58154610/read-and-update-into-json-file-in-main-app-bundle
  // acima eu troco o local
  // como usar o filemanager
  // https://www.swiftyplace.com/blog/file-manager-in-swift-reading-writing-and-deleting-files-and-directories
  func updateUser(name: String, photoUrl: URL, password: String?) {
    let users = loadFileManager(filename: "User.json", type: [UserModel].self)
    var updateUser = users.filter { $0.uid != "3434342JAJApEDRO" }
    let newUser = UserModel(
      uid: "3434342JAJApEDRO",
      displayName: name,
      photoUrl: URL(string: "https://github.com/kenjimaeda54.png"),
      email: "kenji@gmail.com"
    )
    updateUser.append(newUser)

    updateFileManager(filename: "User.json", model: updateUser)
  }
}
