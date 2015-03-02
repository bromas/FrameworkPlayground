//
//  TriangleLayer.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class TriangleLayer: CALayer {
  
//  @NSManaged var sizerz: CGSize
//  
//  override var bounds: CGRect {
//    get {
//      return super.bounds
//    }
//    set {
//      super.bounds = newValue
//    }
//  }
  
//  func makeAnimationForKey(key: String) -> CABasicAnimation {
//    let anim = CABasicAnimation(keyPath: key)
//    let preset = self.presentationLayer()
////    anim.fromValue = 
////    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    anim.duration = 0.5;
//    return anim;
//  }
  
//  func shapeForBounds(bounds: CGRect) -> UIBezierPath {
//    return UIBezierPath()
//  }

  
  override func drawInContext(ctx: CGContext!) {
    let topCenter = CGPoint(x: self.bounds.size.width/2, y: 0)
    let bottomLeft = CGPoint(x: 0, y: self.bounds.size.height)
    let bottomRight = CGPoint(x: self.bounds.size.width, y: self.bounds.size.height)
    
    CGContextBeginPath(ctx)
    CGContextMoveToPoint(ctx, bottomLeft.x, bottomLeft.y)
    CGContextAddLineToPoint(ctx, topCenter.x, topCenter.y)
    CGContextAddLineToPoint(ctx, bottomRight.x, bottomRight.y)
    CGContextClosePath(ctx)
    
    CGContextSetFillColorWithColor(ctx, UIColor.yellowColor().CGColor)
    CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor().CGColor)
    CGContextSetLineWidth(ctx, 1.0)
    
    CGContextDrawPath(ctx, kCGPathFillStroke)
  }
  
//  override class func needsDisplayForKey(key: String!) -> Bool{
//    if key == "angleFrom" || key == "angleTo" {
//      return true;
//    }
//    return super.needsDisplayForKey(key)
//  }
//  
//  override func actionForKey(event: String!) -> CAAction! {
//    if event == "angleFrom" || event == "angleTo" {
//      return self.makeAnimationForKey(event)
//    }
//    return super.actionForKey(event)
//  }
  
}
