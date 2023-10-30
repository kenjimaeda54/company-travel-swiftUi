//
//  SizePreferenceKey.swift
//  Company Travel
//
//  Created by kenjimaeda on 28/10/23.
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}
