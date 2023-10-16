//
//  PointsInterest.swift
//  Company Travel
//
//  Created by kenjimaeda on 16/10/23.
//

import Foundation

struct PointsInterest: Decodable {
  let meta: PointsMeta
  let data: PointsData
}

struct PointsMeta: Decodable {
  let count: String
  let links: PointsLinks
}

struct PointsLinks: Decodable {
  let `self`: String
}

struct PointsData: Decodable {
  let id: String
  let type: String
  let `self`: PointsSelf
  let name: String
  let shortDescription: String
  let geoCode: PointsGeoCode
  let rating: String
  let pictures: [String]
  let bookingLink: String
  let price: PointsPrice
}

struct PointsSelf: Decodable {
  let href: String
  let methods: [String]
}

struct PointsGeoCode: Decodable {
  let latitude: String
  let longitude: String
}

struct PointsPrice: Decodable {
  let currencyCode: String
  let amount: String
}
