//
//  PresentationDetent.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import Foundation
import SwiftUI

extension PresentationDetent {
  static let bar = Self.custom(BarDetent.self)
  static let small = Self.height(150)
  static let extraLarge = Self.fraction(0.75)
}

private struct BarDetent: CustomPresentationDetent {
  static func height(in context: Context) -> CGFloat? {
    max(44, context.maxDetentValue * 0.1)
  }
}
