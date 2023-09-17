//
//  UIImage.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import Foundation
import UIKit

public extension UIImage {
  var hasContent: Bool {
    return cgImage != nil || ciImage != nil
  }
}
