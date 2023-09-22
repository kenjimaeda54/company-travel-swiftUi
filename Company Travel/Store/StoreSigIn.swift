//
//  StorePhone.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import FirebaseAuth
import Foundation

class StoreSigIn: ObservableObject {
  @Published var loading = StateLoading.loading
  @Published var showSheetSelectGaleryOrCamera = false

  let httpClient: HttpClientProtocol

  init(httpClient: HttpClientProtocol) {
    self.httpClient = HttpClientFactory.create()
  }

  func createUser(email: String, password: String, name: String, data: Data?, completion: @escaping (User?) -> Void) {
    httpClient.createUser(email: email, password: password, name: name, data: data) { result in

      switch result {
      case let .success(user):

        DispatchQueue.main.async {
          completion(user)
        }

      case let .failure(error):
        print(error)
        DispatchQueue.main.async {
          completion(nil)
        }
      }
    }
  }

  func handleApresentedSheetGalleryAndPhoto(sheetSelectedGaleryOrCamera: inout Bool) {
    sheetSelectedGaleryOrCamera = false
  }
}