//
//  UIDevice.swift
//  Company Travel
//
//  Created by kenjimaeda on 15/09/23.
//

import Foundation
import UIKit

// para verficar se estamos em modo simulador ou device
// referencia
// https://stackoverflow.com/questions/24869481/how-to-detect-if-app-is-being-built-for-device-or-simulator-in-swift
extension UIDevice {
  var isSimulator: Bool {
#if targetEnvironment(simulator)
    return true
#else
    return false
#endif
  }
}
