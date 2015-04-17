//
//  PersonTableViewModel.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class PersonTableViewModel: TableViewModel {
  
  var collection: [Person] =
  [Person(firstName: "Guy", lastName: "One"),
    Person(firstName: "Lady", lastName: "Two"),
    Person(firstName: "Dude", lastName: "Three"),
    Person(firstName: "Somebody", lastName: "Else"),
    Person(firstName: "Guy", lastName: "One"),
    Person(firstName: "Lady", lastName: "Two"),
    Person(firstName: "Dude", lastName: "Three"),
    Person(firstName: "Somebody", lastName: "Else"),
    Person(firstName: "Guy", lastName: "One"),
    Person(firstName: "Lady", lastName: "Two"),
    Person(firstName: "Dude", lastName: "Three"),
    Person(firstName: "Somebody", lastName: "Else"),
    Person(firstName: "Guy", lastName: "One"),
    Person(firstName: "Lady", lastName: "Two"),
    Person(firstName: "Dude", lastName: "Three"),
    Person(firstName: "Somebody", lastName: "Else")]
  
  func estimatedRowHeight() -> CGFloat {
    return 60.0
  }
  
  func refreshData(completion: () -> Void) {
    
  }
  
  func numberOfItems() -> Int {
    return collection.count
  }
  
  func registerTableViewCell(table: UITableView) -> String {
    table.registerNib(UINib(nibName: "PersonCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "personCellIdentifier")
    return "personCellIdentifier"
  }
  
  func configureCell(cell: UITableViewCell, identifier: String, forIndexPath: Int) {
    let personCell = cell as! PersonCell
    personCell.firstName.text = collection[forIndexPath].firstName
    personCell.lastName.text = collection[forIndexPath].lastName
  }
  
}
