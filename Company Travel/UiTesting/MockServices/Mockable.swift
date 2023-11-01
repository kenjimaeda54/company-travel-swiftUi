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
  func loadFileManager<T: Decodable>(filename: String, type: T.Type) -> T
  func writeFileManager(filename: String, model: Encodable)
}

extension Mockable {
  var fm: FileManager {
    return FileManager.default
  }

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

  func loadFileManager<T: Decodable>(filename: String, type: T.Type) -> T {
    var documentDirectory: URL?

    do {
      let url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      documentDirectory = url.appendingPathComponent(filename)
      print(url)
    } catch {
      print(error.localizedDescription)
    }

    do {
      let data = try Data(contentsOf: (documentDirectory ?? URL(string: ""))!)
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print(error.localizedDescription)
      fatalError("Failed decode json")
    }
  }

  func writeFileManager(filename: String, model: Encodable) {
    var documentDirectory: URL?
    do {
      let url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      documentDirectory = url.appendingPathComponent(filename)
    } catch {
      print(error.localizedDescription)
    }

    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(model)
      try jsonData.write(to: documentDirectory!)
    } catch {
      fatalError("Can't save")
    }
  }

  // https://stackoverflow.com/questions/6137423/how-to-overwrite-a-file-with-nsfilemanager-when-copying
  // update
  // https://stackoverflow.com/questions/6137423/how-to-overwrite-a-file-with-nsfilemanager-when-copying

  // https://developer.apple.com/documentation/foundation/filemanager/1412432-replaceitem
  func updateFileManager<T: Codable>(filename: String, model: T) {
    var documentDirectory: URL?
    var newDocumentDirectory: URL?
    do {
      let url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      documentDirectory = url.appendingPathComponent(filename)

    } catch {
      print(error.localizedDescription)
    }

    do {
      let newUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      newDocumentDirectory = newUrl.appendingPathComponent(filename)
      try fm.replaceItemAt(documentDirectory!, withItemAt: newDocumentDirectory!)
      print(newDocumentDirectory)
    } catch {
      print(error.localizedDescription)
    }

    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(model)
      try jsonData.write(to: newDocumentDirectory!)
    } catch {
      fatalError("Can't save")
    }
  }
}
