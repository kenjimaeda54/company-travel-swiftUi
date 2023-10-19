//
//  PointsInterest.swift
//  Company Travel
//
//  Created by kenjimaeda on 16/10/23.
//

import Foundation

struct PointsInterestModel: Decodable {
  let data: [PointsData]
}

struct PointsData: Decodable {
  let type: String
  let subType: String
  let id: String
  let `self`: PointsSelf
  let geoCode: PointsGeoCode
  let name: String
  let category: String
  let rank: Int
  let tags: [String]
}

struct PointsMeta: Decodable {
  let count: String
  let links: PointsLinks
}

struct PointsLinks: Decodable {
  let `self`: String
}

struct PointsSelf: Decodable {
  let href: String
  let methods: [String]
}

struct PointsGeoCode: Decodable {
  let latitude: Double
  let longitude: Double
}

struct PointsPrice: Decodable {
  let currencyCode: String
  let amount: String
}
