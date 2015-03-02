//
//  BackInNavStrategy.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import StrategicControllers

typealias TablesIntroNavStrategy = tablesIntroNavStrategy<Int>
class tablesIntroNavStrategy<Int> : ControllerStrategy<TablesIntroController> {
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "TableWithModel" {
      (segue.destinationViewController as! TableViewWithModel).setStrategy(TableWithVMTablesStrategy())
      (segue.destinationViewController as! TableViewWithModel).configure(viewModel: PostTableViewModel())
    }
  }
  
  override func viewDidLoad() {
    controller.prepareForAppearingAnimation = { [unowned self] (completion) in
      let animation = CAColorAnimation("backgroundColor", from: UIColor.redColor(), to: UIColor.blackColor(), 0.7)
      self.controller.underView.layer.addAnimation(animation, forKey: "backgroundColorChange")
      self.controller.underView.backgroundColor = UIColor.blackColor()
    }
    
    controller.animateAppeared = { [unowned self] (completed, completion) in
      CATransaction.begin()
      CATransaction.setCompletionBlock() {
        completion(didComplete: completed)
      }
      CATransaction.setAnimationDuration(0.2)
      let animation = CAColorAnimation("backgroundColor", from: UIColor.blackColor(), to: UIColor.whiteColor(), 0.2)
      self.controller.underView.layer.addAnimation(animation, forKey: "backgroundColorChange")
      CATransaction.commit()
      
      self.controller.underView.backgroundColor = UIColor.whiteColor()
    }
  }
  
}
