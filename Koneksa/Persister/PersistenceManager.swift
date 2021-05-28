//
//  PersistenceManager.swift
//  Koneksa
//
//  Created by Nick Nguyen on 3/28/21.
//

import Foundation

struct Persister {

  let fileURL: URL

  let plistEncoder = PropertyListEncoder()

  let plistDecoder = PropertyListDecoder()

  init?(withFileName fileName: String) {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) else {
      return nil
    }
    print("PATH: \(url)")
    fileURL = url
  }

  func save<T: Codable>(_ object: T) {
    do {
      let accelerometerData = try plistEncoder.encode(object)
      try accelerometerData.write(to: fileURL)
    } catch let err as NSError {
      print(err.localizedDescription)
    }
  }

  func fetch<T: Codable>() throws -> T {
    let accelerometerData = try Data(contentsOf: fileURL)
    let data = try plistDecoder.decode(T.self, from: accelerometerData)
    return data
  }
}
