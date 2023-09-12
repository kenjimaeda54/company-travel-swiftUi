//
//  HttpClientProtocol.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation

enum HttpError: Error {
  case badURL, badResponse, errorEncodingData, noData, invalidURL, invalidRequest
}

enum StateLoading {
  case loading, failure, sucess
}

protocol HttpClientProtocol {
  func fetchDestination(completion: @escaping (Result<[DestinationModel], HttpError>) -> Void)
}
