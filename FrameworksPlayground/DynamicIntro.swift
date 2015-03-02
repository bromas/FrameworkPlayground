//
//  DynamicIntro.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/6/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ApplicationViewController
import Architect

class DynamicIntro : ViewController {
  
  var dynamicsView: UIView!
  var animator: UIDynamicAnimator!
  var gravity: UIGravityBehavior!
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    ActivityOperation(identifier: "Intro", animator: SpringSlideAnimator(direction: .Left)).execute()
    return
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    self.animat
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    self.view.backgroundColor = UIColor.blackColor()
    self.dynamicsView = Architect.view(inView: self.view) { (view) in
      Constrain.inset(view, with: [.Top: 120, .Right: 20, .Bottom: 20, .Left: 20])
      return
    }
    
    self.animator = UIDynamicAnimator(referenceView: self.dynamicsView)
    let dropView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
    dropView.backgroundColor = UIColor.greenColor()
    dropView.alpha = 1.0
    self.dynamicsView.addSubview(dropView)
    self.dynamicsView.backgroundColor = UIColor.redColor()
    self.gravity = UIGravityBehavior(items: [dropView])
    self.animator.addBehavior(self.gravity)
  }
}
