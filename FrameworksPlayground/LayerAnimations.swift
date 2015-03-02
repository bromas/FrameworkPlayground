//
//  LayerAnimations.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

func CAColorAnimation(keyPath: String, #from: UIColor?, #to: UIColor?, duration: NSTimeInterval) -> CABasicAnimation {
  let animation = CABasicAnimation(keyPath: keyPath)
  animation.fromValue = from!.CGColor
  animation.duration = duration
  animation.toValue = to!.CGColor
  return animation
}

func CATranslationAnimation(from: CGSize, duration: NSTimeInterval, delay: CFTimeInterval) -> CABasicAnimation {
  let animation = CABasicAnimation(keyPath: "position")
  animation.fromValue = NSValue(CGSize: from)
  animation.duration = duration
  return animation
}

func CAScaleTransformAnimation(forLayer: CALayer, duration: NSTimeInterval, delay: CFTimeInterval) -> CABasicAnimation {
  let animation = CABasicAnimation(keyPath: "transform")
  var transform = CATransform3DIdentity
  transform = CATransform3DTranslate(transform, forLayer.bounds.size.width/2, forLayer.bounds.size.height/2, 0)
  animation.fromValue = NSValue(CATransform3D: transform)
  animation.duration = duration
  return animation
}
/*
CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
CATransform3D tr = CATransform3DIdentity;
tr = CATransform3DTranslate(tr, self.bounds.size.width/2, self.bounds.size.height/2, 0);
tr = CATransform3DScale(tr, 3, 3, 1);
tr = CATransform3DTranslate(tr, -self.bounds.size.width/2, -self.bounds.size.height/2, 0);
scale.toValue = [NSValue valueWithCATransform3D:tr];
*/
