//
//  HttpClientProtocol.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import FirebaseAuth
import Foundation

enum HttpError: Error {
  case badURL, badResponse, errorEncodingData, noData, invalidURL, invalidRequest, errorUploadPhoto, errorUpdateUser,
       errorEmailorPasswordWrong, errorCreateUser
}

enum StateLoading {
  case loading, failure, sucess, waiting
}

protocol HttpClientProtocol {
  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void)
  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  )
  func sigIn(
    email: String,
    password: String,
    completion: @escaping (Result<UserModel, HttpError>) -> Void
  )
  func getFavoritesByUser(idUser: String, completion: @escaping (Result<[FavoriteModel], HttpError>) -> Void)

  func addFavorite(favorite: FavoriteModel)

  func removeFavorite(documentId: String)

  func getUserLoged(completion: @escaping (UserModel?) -> Void)

  func signOut() -> Void

  func getPointsInterest(
    geocode: PointsGeoCode,
    completion: @escaping (Result<PointsInterestModel, HttpError>) -> Void
  )

  func updateUser(name: String, photoUrl: URL, password: String?) -> Void

  func converterDataFromUrlRequest(
    data: Data?,
    reference: String,
    completion: @escaping (Result<URL, HttpError>) -> Void
  ) -> Void
}
