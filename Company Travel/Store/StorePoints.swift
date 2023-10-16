//
//  StorePoints.swift
//  Company Travel
//
//  Created by kenjimaeda on 16/10/23.
//

import Foundation

class StorePoints: ObservableObject {
  @Published var isLoading = StateLoading.loading
  var pointsInterest: PointsInterest? = nil
  var httpCLient: HttpClientProtocol

  init(
    isLoading: StateLoading = StateLoading.loading,
    pointsInterest: PointsInterest? = nil,
    httpCLient: HttpClientProtocol
  ) {
    self.isLoading = isLoading
    self.pointsInterest = pointsInterest
    self.httpCLient = httpCLient
  }

  func getAllPointsInreset(geoCode: PointsGeoCode) {
    httpCLient.getPointsInterest(geocode: geoCode) { result in

      switch result {
      case let .failure(error):
        print(error)
        DispatchQueue.main.async {
          self.isLoading = StateLoading.failure
        }

      case let .success(data):
        DispatchQueue.main.async {
          self.isLoading = StateLoading.sucess
          self.pointsInterest = data
        }
      }
    }
  }
}
