//
//  AppNetPostRequestsManager.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 4/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Runes
import Argo
import Alamofire

enum ProvidedImage {
  case found(UIImage)
  case mocked(UIImage?)
}

class AppNetPostRequestsManager {
  
  let coalesce = BCCoalesce()
  var userIDIconMap: [String: UIImage] = [:]
  
  init () {
    coalesce.resultsInterpolator = { data in
      let target = data as! NSData
      return UIImage(data: target)
    }
  }
  
  func recentPosts(completion: ([AppNetPost]) -> Void) -> Void {
    Alamofire.request(.GET, "https://alpha-api.app.net/stream/0/posts/stream/global").responseArgoJSON({ _, _, json, _ in
      let result = AppNetPostsResponse.decode(json)?.posts ?? { return [] }()
      completion(result)
    })
  }
  
  func localImageForUser(forUser: AppNetUser) -> ProvidedImage {
    let possibleImage = userIDIconMap[forUser.userID]
    if let foundImage = possibleImage {
      return ProvidedImage.found(foundImage)
    }
    return ProvidedImage.mocked(.None)
  }
  
  func downloadImageForUser(forUser: AppNetUser, completion: (UIImage?) -> Void) -> Void {
    
    let globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(globalConcurrentQueue) { [unowned self] in
      self.coalesce.addCallbacksWithProgress({ (percent) -> Void in return }, andCompletion: { (data, response, error) -> Void in
        dispatch_async(dispatch_get_main_queue()) {
          self.userIDIconMap[forUser.userID] = data as? UIImage
          completion(self.userIDIconMap[forUser.userID])
        }
        }, forIdentifier: forUser.userID) { () -> Void in
          Alamofire.request(.GET, forUser.avatarUrl).response { (_, _, data, error) -> Void in
            self.coalesce.identifier(forUser.userID, completedWithData: data as! NSData, andError: error)
          }
          return
      }
    }
    
  }
}