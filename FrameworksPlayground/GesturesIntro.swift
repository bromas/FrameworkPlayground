//
//  GesturesIntro.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/10/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class GesturesIntro : ViewController {
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    ActivityOperation(identifier: "Intro", animator: SpringSlideAnimator(direction: .Left)).execute()
  }
  
}
