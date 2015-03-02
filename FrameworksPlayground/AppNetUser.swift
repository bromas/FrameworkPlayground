//
//  AppNetPostsResponse.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/5/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Runes
import Argo

struct AppNetUser : Printable {
  
  var userName: String
  let userID: String
  let avatarUrl: String
  
  var description: String {
    get {
      return "name: \(userName), id: \(userID), avatarURL: \(avatarUrl)"
    }
  }
}

extension AppNetUser : JSONDecodable {
  
  static func createUser(userName: String)(userID: String)(avatarUrl: String) -> AppNetUser {
    return AppNetUser(userName: userName, userID: userID, avatarUrl: avatarUrl)
  }
  
  static func decode(argo: Argo.JSONValue) -> AppNetUser? {
    return AppNetUser.createUser
      <^> argo <| "username"
      <*> argo <| "id"
      <*> argo <| ["avatar_image", "url"]
  }
  
}
