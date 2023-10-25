//
//  constants.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation
import SwiftUI

var gridItemDestinations: [GridItem] {
  return Array(repeating: GridItem(.flexible(), spacing: 17), count: 2)
}

enum ConstantsAppStorage: String {
  case verficationIdAuth
}

enum ConstantsTestApp: String {
  case homeGridDestination
  case rowGridDestination
}
