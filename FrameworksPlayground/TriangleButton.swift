//
//  TriangleButton.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/18/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class TriangleButton: ShapeButton {
  
  override class func layerClass() -> AnyClass {
    return TriangleLayer.self
  }
  
}