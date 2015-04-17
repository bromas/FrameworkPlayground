//
//  CellRegistrationConfiguration.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 4/16/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

protocol CellRegistrationConfiguration {
  func registerToTable(table: UITableView) -> String
}

class CellNibConfiguration<T>: CellRegistrationConfiguration {
  var cellIdentifier: String = ""
  var cell: UINib?
  
  init(identifier: String, nib: UINib) {
    cellIdentifier = identifier
    cell = nib
  }
  
  var configureBlock: (UITableViewCell, T) -> Void = { cell, model in
    return
  }
  
  func registerToTable(table: UITableView) -> String {
    if let nib = self.cell {
      table.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
    }
    return cellIdentifier
  }
}

class CellClassConfiguration<T>: CellRegistrationConfiguration {
  var cellIdentifier: String = "cellIdentifier"
  var cellClass: AnyClass = UITableViewCell.self
  
  init(identifier: String, klass: AnyClass) {
    cellIdentifier = identifier
    cellClass = klass
  }
  
  var configureBlock: (UITableViewCell, T) -> Void = { cell, model in
    return
  }
  
  func registerToTable(table: UITableView) -> String {
    table.registerClass(cellClass, forCellReuseIdentifier: cellIdentifier)
    return cellIdentifier
  }
}

// Boo - Can't rely on this for type safety... subclass overrides the generic...
typealias AppNetPostCellConfiguration = appNetPostCellConfiguration<Int>
class appNetPostCellConfiguration<T>: CellClassConfiguration<AppNetPost> {
  override init(identifier: String, klass: AnyClass) {
    super.init(identifier: identifier, klass: klass)
    self.configureBlock = { cell, post in
      let appNetPostCell = cell as! AppNetPostCell
      appNetPostCell.userNameLabel.text = post.user.userName
      appNetPostCell.postLabel.text = post.text
    }
  }
}