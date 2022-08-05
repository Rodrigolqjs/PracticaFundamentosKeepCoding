//
//  LocalDataModel.swift
//  PracticaDragonBall
//
//  Created by Rodrigo Latorre on 5/08/22.
//

import Foundation

private enum Constant {
  static let tokenKey = "KCToken"
}

final class LocalDataModel {
  private static let userDefaults = UserDefaults.standard
  
  static func getToken() -> String? {
    userDefaults.string(forKey: Constant.tokenKey)
  }
  
  static func save(token: String) {
    userDefaults.set(token, forKey: Constant.tokenKey)
  }
  
  static func deleteToken() {
    userDefaults.removeObject(forKey: Constant.tokenKey)
  }
}
