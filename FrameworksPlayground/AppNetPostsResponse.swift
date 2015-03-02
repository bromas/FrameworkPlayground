//
//  AppNetPostsResponse.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/13/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Argo
import Runes

struct AppNetPostsResponse {
  
  var posts: [AppNetPost]
  
}

extension AppNetPostsResponse: JSONDecodable {
  
  static func create(posts: [AppNetPost]) -> AppNetPostsResponse {
    return AppNetPostsResponse(posts: posts)
  }
  
  static func decode(json: Argo.JSONValue) -> AppNetPostsResponse? {
    return AppNetPostsResponse.create <^> json <|| "data"
  }
}
