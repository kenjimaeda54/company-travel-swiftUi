//
//  MaxLengthCharacter.swift
//  Company Travel
//
//  Created by kenjimaeda on 14/09/23.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
  func max(_ limit: Int) -> Self {
    if wrappedValue.count > limit {
      DispatchQueue.main.async {
        self.wrappedValue = String(self.wrappedValue.dropLast())
      }
    }
    return self
  }
}
