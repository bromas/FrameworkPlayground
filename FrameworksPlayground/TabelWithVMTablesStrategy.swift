//
//  TabelWithViewModelBackStrategy.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import StrategicControllers
import ApplicationViewController

typealias TableWithVMTablesStrategy = tableWithVMTablesStrategy<Int>
class tableWithVMTablesStrategy<Int> : ControllerStrategy<TableViewWithModelAdditions> {
  
  override func viewDidLoad() {
    
//    controller.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Lower", style: .Plain, target: controller, action: "tempButtonTap")
    
    controller.actionOnTempButtonTap = { () in
      ActivityOperation(identifier: "List", animator: OpenAndThroughAnimator(open: .Horizontal, direction: .Out, duration: 0.6)).execute()
      return
    }
    
  }
}