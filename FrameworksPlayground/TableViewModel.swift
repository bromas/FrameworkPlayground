//
//  TableViewModel.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewModel {
  
  func estimatedRowHeight() -> CGFloat
  func numberOfItems() -> Int
    
  func refreshData(completion: () -> Void) -> Void
  func configureCell(cell: UITableViewCell, identifier: String, forIndexPath: Int)
  
}
