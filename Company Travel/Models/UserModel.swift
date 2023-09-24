//
//  UserModel.swift
//  Company Travel
//
//  Created by kenjimaeda on 23/09/23.
//

import Foundation

struct UserModel: Codable {
  let displayName: String?
  let photoUrl: URL?
  let email: String?
}
