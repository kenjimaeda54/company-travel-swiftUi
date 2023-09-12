//
//  constants.swift
//  Company Travel
//
//  Created by kenjimaeda on 11/09/23.
//

import Foundation
import SwiftUI

let rowSpacing: CGFloat = 13
var gridItemDestionation: [GridItem] {
  return Array(repeating: GridItem(.flexible(), spacing: rowSpacing), count: 2)
}
