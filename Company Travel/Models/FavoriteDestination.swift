//
//  FavoriteDestination.swift
//  Company Travel
//
//  Created by kenjimaeda on 22/10/23.
//

import Foundation

struct FavoriteDestination: Codable, Identifiable {
  let id: String
  let destination: DestinationModel
}
