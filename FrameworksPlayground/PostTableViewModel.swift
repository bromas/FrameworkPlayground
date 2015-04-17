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

class PostTableViewModel<T>: TableViewModel {
  
  var collection: [AppNetPost] = []
  var cellConfiguration: CellNibConfiguration<AppNetPost>?
  var requestManager: AppNetPostRequestsManager?
  
  init() { }
  
  func estimatedRowHeight() -> CGFloat {
    return 80.0
  }
  
  func refreshData(completion: () -> Void) {
    requestManager?.recentPosts { posts in
      self.collection = posts
      completion()
    }
  }
  
  func numberOfItems() -> Int {
    return collection.count
  }
  
  func registerCellConfiguration(configuration: CellNibConfiguration<AppNetPost>) {
    cellConfiguration = configuration
  }
  
  func configureCell(cell: UITableViewCell, identifier: String, forIndexPath: Int) {
    let appNetPost = collection[forIndexPath]
    self.cellConfiguration?.configureBlock(cell, appNetPost)
  }

  
}
