//
//  HttpClientProtocol.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import FirebaseAuth
import Foundation

enum HttpError: Error {
  case badURL, badResponse, errorEncodingData, noData, invalidURL, invalidRequest, errorUploadPhoto, errorUpdateUser
}

enum StateLoading {
  case loading, failure, sucess
}

protocol HttpClientProtocol {
  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void)
  func createUser(
    email: String,
    password: String,
    name: String,
    data: Data?,
    completion: @escaping (Result<User, HttpError>) -> Void
  )
}
