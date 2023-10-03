//
//  FavoriteModel.swift
//  Company Travel
//
//  Created by kenjimaeda on 27/09/23.
//

import Foundation

// https://stackoverflow.com/questions/29552399/should-a-dictionary-be-converted-to-a-class-or-struct-in-swift
struct FavoriteModel {
  let id: String
  let idDestination: String
  let idUser: String
}

extension FavoriteModel: Codable {
  init(dictionary: [String: Any]) throws {
    self = try JSONDecoder().decode(FavoriteModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
  }
}
