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
    completion: @escaping (Result<User, HttpError>) -> Void
  ) {}

  func sigIn(
    email: String,
    password: String,
    completion: @escaping (Result<User, HttpError>) -> Void
  ) {}
}
