//
//  AppNetPost.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/5/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Argo
import Runes

struct AppNetPost : Printable {

  let id: String
  let created: String
  let text: String
  let user: AppNetUser
  
  var description: String {
    get {
      return "By: \(user), Text: \(text)"
    }
  }
}

extension AppNetPost : JSONDecodable {
  
  static func create(id: String)(created: String)(text: String)(user: AppNetUser) -> AppNetPost {
    return AppNetPost(id: id, created: created, text: text, user: user)
  }
  
  static func decode(argo: Argo.JSONValue) -> AppNetPost? {
    return AppNetPost.create
      <^> argo <| "id"
      <*> argo <| "created_at"
      <*> argo <| "text"
      <*> argo <| "user"
  }
  
}

