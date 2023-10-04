//
//  Mockable.swift
//  Company Travel_Tests
//
//  Created by kenjimaeda on 20/09/23.
//

import Foundation

// implementar o write on json
// https://stackoverflow.com/questions/42550657/writing-json-file-programmatically-swift

protocol Mockable: AnyObject {
  var bundle: Bundle { get }
  func loadJson<T: Decodable>(filename: String, type: T.Type) -> T
}

extension Mockable {
  var bundle: Bundle {
    return Bundle(for: type(of: self))
  }

  func loadJson<T: Decodable>(filename: String, type: T.Type) -> T {
    guard let path = bundle.url(forResource: filename, withExtension: "json") else {
      fatalError("Failed to load Json file")
    }

    do {
      let data = try Data(contentsOf: path)
      let decodeObject = try JSONDecoder().decode(T.self, from: data)
      return decodeObject
    } catch {
      print(error.localizedDescription)
      fatalError("Failed decode json")
    }
  }
}
