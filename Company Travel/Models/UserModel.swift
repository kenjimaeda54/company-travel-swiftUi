//
//  UserModel.swift
//  Company Travel
//
//  Created by kenjimaeda on 23/09/23.
//

import Foundation

struct UserModel: Codable {
  var uid: String
  var displayName: String?
  var photoUrl: URL?
  var email: String?
}
