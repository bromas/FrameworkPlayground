//
//  TableAnimatingStrategy.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import StrategicControllers
import ActivityViewController

typealias TableAnimatingStrategy = tableAnimatingStrategy<Int>
class tableAnimatingStrategy<Int> : ControllerStrategy<TableViewWithModelAdditions> {
  
  override func viewDidLoad() {
    
    controller.prepareForAppearingAnimation = { [unowned self] () -> Void in
      for (index, cell) in enumerate(self.controller.table.visibleCells()) {
        let indexD = Double(index)
        
        if let tableCell = cell as? UITableViewCell {
          tableCell.contentView.layer.addAnimation(CATranslationAnimation(CGSize(width: 300, height: 0), 0.8, 0.1), forKey: "wat")
        }
        
      }
    }
    
    controller.animateAppeared = { [unowned self] (completion) in
      for (index, cell) in enumerate(self.controller.table.visibleCells()) {
        let indexD = Double(index)
        if let tableCell = cell as? UITableViewCell {
          tableCell.layer.addAnimation(CATranslationAnimation(CGSize(width: 300, height: 0), 0.8, 0.1), forKey: "wat")
        }
      }
    }
    
    controller.animateDisappearing = { [unowned self] (completion) in
      let animations = { () -> Void in
        let count = Double(self.controller.table.visibleCells().count)
        for (index, cell) in enumerate(self.controller.table.visibleCells()) {
          let indexD = Double(index)
          UIView.addKeyframeWithRelativeStartTime((indexD/(2*count)), relativeDuration: 0.5, animations: { () -> Void in
            if let tableCell = cell as? UITableViewCell {
              tableCell.transform = CGAffineTransformMakeTranslation(500, 0)
            }
          })
        }
      }
      UIView.animateKeyframesWithDuration(0.8, delay: 0.0, options: UIViewKeyframeAnimationOptions(0), animations: animations, completion: nil)
      completion(didComplete: true)
    }
    
    controller.resolveDisappearingAnimation = { () in
      let count = Double(self.controller.table.visibleCells().count)
      for (index, cell) in enumerate(self.controller.table.visibleCells()) {
        if let tableCell = cell as? UITableViewCell {
          tableCell.transform = CGAffineTransformIdentity
        }
      }
    }
    
  }
  
}
