//
//  CircleButton.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/18/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class CircleButton: UIControl {
  
  @IBOutlet var actionLabel: UILabel!
  
  override class func layerClass() -> AnyClass {
    return CAShapeLayer.self
  }
  
  var shapeLayer: CAShapeLayer! { get {
    return self.layer as! CAShapeLayer
    }}
  
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
    self.shapeLayer.path = circlePathForBounds().CGPath
    self.shapeLayer.fillColor = UIColor.purpleColor().CGColor
    self.layer.setNeedsDisplay()
  }
  
  func circlePathForBounds() -> UIBezierPath {
    let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    let top = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
    
    var path = UIBezierPath()
    path.moveToPoint(top)
    path.addArcWithCenter(center, radius: self.bounds.size.height/2, startAngle: 0, endAngle: 360, clockwise: true)
    path.closePath()
    
    return path;
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
