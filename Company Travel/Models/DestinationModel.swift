//
//  Destionation.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation

struct DestinationModel: Identifiable, Decodable {
  let id: String
  let location: String
  let overview: String
  let pointsActivies: [Double]
  let poster: String
  let price: String
  let title: String
}
