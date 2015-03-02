//
//  SquareButton.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/18/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class SquareButton: ShapeButton {
  
  override class func layerClass() -> AnyClass {
    return SquareLayer.self
  }
  
}
