//
//  StorePhone.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import FirebaseAuth
import Foundation

class StoreLogin: ObservableObject {
  @Published var loading = StateLoading.loading
  var tokenAuth: OAuthCredential? = nil
  let httpClient: HttpClientProtocol

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
  }
}
