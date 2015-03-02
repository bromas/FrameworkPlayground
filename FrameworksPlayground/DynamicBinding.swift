//
//  DynamicBinding.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/6/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class DynamicBinding: NSObject, UIDynamicItem {
  
  var center: CGPoint = CGPointZero
  var bounds: CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
  var transform: CGAffineTransform = CGAffineTransformIdentity
  
}
