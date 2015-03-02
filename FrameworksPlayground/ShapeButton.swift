//
//  TriangleButton.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class ShapeButton: UIControl {
  
  @IBOutlet var actionLabel: UILabel!
  
  override class func layerClass() -> AnyClass {
    return TriangleLayer.self
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.backgroundColor = UIColor.clearColor()
    self.actionLabel = Architect.label(inView: self) {
      Constrain.center($0, with: [.X:0, .Y:20])
      $0.font = UIFont.systemFontOfSize(10)
      $0.text = "ShapeButton"
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.setNeedsDisplay()
  }
  
  override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
    UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.75, options: UIViewAnimationOptions(0), animations: { () -> Void in
      self.transform = CGAffineTransformMakeScale(0.9, 0.9)
      self.alpha = 0.8
      }, completion: nil)
    return true
  }
  
  override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.9, options: UIViewAnimationOptions(0), animations: { () -> Void in
      self.transform = CGAffineTransformIdentity
      self.alpha = 1.0
      }, completion: nil)
  }
  
  override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
    return true
  }
  
  override func cancelTrackingWithEvent(event: UIEvent?) {
    UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.9, options: UIViewAnimationOptions(0), animations: { () -> Void in
      self.transform = CGAffineTransformIdentity
      self.alpha = 1.0
    }, completion: nil)
  }
  
}
