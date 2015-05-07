//
//  PostsTableViewModelWoven.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 4/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Argo
import Alamofire
import Runes
import BCCoalescing

class PostTableViewModelWoven: TableViewModel {
  
  var collection: [AppNetPost] = []
  var userIDIndexMap: [String: [Int]] = [:]
  var userIDIconMap: [String: UIImage] = [:]
  var table: UITableView?
  let coalescing = BCCoalesce()
  var cellConfiguration: CellNibConfiguration<AppNetPost>?
  
  init() { }
  
  func estimatedRowHeight() -> CGFloat {
    return 80.0
  }
  
  func refreshData(completion: () -> Void) {
    Alamofire.request(.GET, "https://alpha-api.app.net/stream/0/posts/stream/global").responseArgoJSON({ _, _, json, _ in
      self.collection = AppNetPostsResponse.decode(json)?.posts ?? { return [] }()
      self.userIDIndexMap = indexMap(self.collection, { $0.user.userID })
      completion()
    })
  }
  
  func numberOfItems() -> Int {
    return collection.count
  }
  
  func registerCellConfiguration(configuration: CellNibConfiguration<AppNetPost>) {
    cellConfiguration = configuration
  }
  
  func registerTable(table: UITableView) {
    self.table = table
  }
  
  func configureCell(cell: UITableViewCell, identifier: String, forIndexPath: Int) {
    let appNetPost = collection[forIndexPath]
    self.cellConfiguration?.configureBlock(cell, appNetPost)
    let appNetPostCell = cell as? AppNetPostCell
    appNetPostCell?.avatarView.image = userIDIconMap[appNetPost.user.userID] ?? downloadWithDefaultImage(appNetPost.user)
  }
  
  func downloadWithDefaultImage(forUser: AppNetUser) -> UIImage? {
    
    coalescing.resultsInterpolator = { data in
      let target = data as! NSData
      return UIImage(data: target)
    }
    
    let globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_async(globalConcurrentQueue) { [unowned self] in
      self.coalescing.addCallbackWithProgress({ (percent) -> Void in return }, andCompletion: { (data, response, error) -> Void in
        dispatch_async(dispatch_get_main_queue()) {
          self.userIDIconMap[forUser.userID] = data as? UIImage
          self.updateTableWithUserIcon(forUser)
        }
        }, forIdentifier: forUser.userID) { () -> Void in
          Alamofire.request(.GET, forUser.avatarUrl).response { (_, _, data, error) -> Void in
            self.coalescing.identifier(forUser.userID, completedWithData: data as! NSData, andError: error)
          }
          return
      }
    }
    
    return UIImage(named: "")
  }
  
  func updateTableWithUserIcon(user: AppNetUser) {
    userIDIndexMap[user.userID]?.map { (itemNumber) -> NSIndexPath in
      NSIndexPath.fromItemNumber(itemNumber)
      }.map { (index) -> AppNetPostCell? in
        self.table?.cellForRowAtIndexPath(index) as? AppNetPostCell
      }.map { (cell) -> Void? in
        cell?.updateAvatarIcon <*> self.userIDIconMap[user.userID]
    }
  }
  
}

extension NSIndexPath {
  class func fromItemNumber(item: Int) -> NSIndexPath {
    return NSIndexPath(forItem: item, inSection: 0)
  }
}
