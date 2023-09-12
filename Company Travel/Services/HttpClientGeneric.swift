//
//  HttpClientGeneric.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation

// referencia
// https://github.com/codewithchris/YT-Vapor-iOS-App/blob/lesson-5/YT-Vapor-iOS-App/Utilities/HttpClient.swift
class HttpClientGeneric {
  static func fetch<T: Decodable>(urlString: String) async throws -> T {
    guard let url = URL(string: urlString) else {
      throw fatalError("Url invalid")
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw fatalError("No data")
    }

    guard let object = try? JSONDecoder().decode(T.self, from: data) else {
      throw fatalError("Problem with decode")
    }

    return object
  }
}
