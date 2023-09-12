//
//  HttpClient.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import FirebaseFirestore
import Foundation

class HttpClient: HttpClientProtocol {
  static var destination: [DestinationModel] = []
  static let db = Firestore.firestore()

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
}
