//
//  PostTableViewModel.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/5/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Argo
import Alamofire
import Runes

class PostTableViewModel: TableViewModel {
  
  var collection: [AppNetPost] = []
  var userIDIndexMap: [String: [Int]] = [:]
  var userIDIconMap: [String: UIImage] = [:]
  var table: UITableView?
  let coalescing = BCCoalesce()
  
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
  
  func registerTableViewCell(table: UITableView) -> String {
    table.registerNib(UINib(nibName: "AppNetPost", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "personCellIdentifier")
    self.table = table
    return "personCellIdentifier"
  }
  
  func configureCell(cell: UITableViewCell, forIndexPath: Int) {
    let appNetPost = collection[forIndexPath]
    let appNetPostCell = cell as? AppNetPostCell
    appNetPostCell?.userNameLabel.text = appNetPost.user.userName
    appNetPostCell?.postLabel.text = appNetPost.text
    appNetPostCell?.avatarView.image = userIDIconMap[appNetPost.user.userID] ?? downloadWithDefaultImage(appNetPost.user)
  }
  
  func downloadWithDefaultImage(forUser: AppNetUser) -> UIImage? {
    
    coalescing.addCallbacksWithProgress({ (percent) -> Void in return }, andCompletion: { (data, response, error) -> Void in
      let globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      dispatch_async(globalConcurrentQueue) {
        let image = UIImage(data: data as! NSData)
        dispatch_async(dispatch_get_main_queue()) {
          self.userIDIconMap[forUser.userID] = image
          self.updateTableWithUserIcon(forUser)
        }
      }
    }, forIdentifier: forUser.userID) { [unowned self] () -> Void in
      Alamofire.request(.GET, forUser.avatarUrl).response { (_, _, data, error) -> Void in
        self.coalescing.identifier(forUser.userID, completedWithData: data as! NSData, andError: error)
      }
      return
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
