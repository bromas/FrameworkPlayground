//
//  ViewController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/9/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import StrategicControllers

class ViewController: StrategicController, TransitionParticipant {
  
  var prepareForAppearingAnimation : () -> Void = { () -> Void in }
  var animateAppeared : (completed: Bool, completion: (didComplete :Bool) -> Void) -> Void = { (completed, completion) in
    completion(didComplete: completed)
  }
  
  var animateDisappearing : (completion: (didComplete :Bool) -> Void) -> Void = { (completion) -> Void in
    completion(didComplete: true)
  }
  var resolveDisappearingAnimation : () -> Void = { () in }
  
}