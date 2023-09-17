//
//  HelpersFunction.swift
//  Company Travel
//
//  Created by kenjimaeda on 16/09/23.
//

import Foundation

func returnIsValiteField(value: String, pattern: String) -> Bool {
  let range = NSRange(location: 0, length: value.utf16.count)
  do {
    let regexEmail = try NSRegularExpression(pattern: pattern)
    return regexEmail.firstMatch(in: value, range: range) != nil
  } catch {
    return false
  }
}
