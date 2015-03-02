//
//  SquareLayer.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/18/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class SquareLayer: CALayer {
  
  override func drawInContext(ctx: CGContext!) {
    let topLeft = CGPoint(x: 0, y: 0)
    let topRight = CGPoint(x: self.bounds.size.width, y: 0)
    let bottomLeft = CGPoint(x: 0, y: self.bounds.size.height)
    let bottomRight = CGPoint(x: self.bounds.size.width, y: self.bounds.size.height)
    
    CGContextBeginPath(ctx)
    CGContextMoveToPoint(ctx, bottomLeft.x, bottomLeft.y)
    CGContextAddLineToPoint(ctx, topLeft.x, topLeft.y)
    CGContextAddLineToPoint(ctx, topRight.x, topRight.y)
    CGContextAddLineToPoint(ctx, bottomRight.x, bottomRight.y)
    CGContextClosePath(ctx)
    
    CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
    CGContextSetStrokeColorWithColor(ctx, UIColor.clearColor().CGColor)
    CGContextSetLineWidth(ctx, 1.0)
    
    CGContextDrawPath(ctx, kCGPathFillStroke)
  }
  
}