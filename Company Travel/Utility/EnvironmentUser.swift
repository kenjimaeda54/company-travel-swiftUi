//
//  EnvironmentUser.swift
//  Company Travel
//
//  Created by kenjimaeda on 25/09/23.
//

import FirebaseAuth
import Foundation

class EnvironmentUser: ObservableObject {
  @Published var user: UserModel = .init(
    uid: "",
    displayName: "",
    photoUrl: URL(string: "http://github.com/kenjimaeda54.png")!,
    email: ""
  )
}
