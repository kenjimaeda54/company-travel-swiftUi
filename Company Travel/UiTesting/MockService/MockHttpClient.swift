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
    let users = loadJson(filename: "User", type: [UserModel].self)

    if users.contains(where: { $0.email == email }) {
      return completion(.failure(.badResponse))
    }
    let userModel = UserModel(
      uid: "32434FbE3",
      displayName: name,
      photoUrl: URL(string: "https://github.com/kenjimaeda54.png")!,
      email: email
    )

    completion(.success(userModel))
  }

  func sigIn(
    email: String,
    password: String,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  ) {
    let users = loadJson(filename: "User", type: [UserModel].self)
    let findUser = users.first { $0.email == email }

    if findUser != nil && password == "Abacate54@" {
      return completion(.success(findUser!))
    }

    completion(.failure(.badResponse))
  }

  func getFavoritesByUser(idUser: String, completion: @escaping (Result<[FavoriteModel], HttpError>) -> Void) {
    completion(.failure(.badResponse))
  }

  func addFavorite(favorite: FavoriteModel) {}

  func removeFavorite(documentId: String) {}
}