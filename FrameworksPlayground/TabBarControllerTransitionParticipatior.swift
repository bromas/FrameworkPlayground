//
//  TabBarControllerTransitionParticipatior.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/9/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController : TransitionParticipant {
  
  var prepareForAppearingAnimation : () -> Void {
    get {
      let controller = self.selectedViewController as? TransitionParticipant
      if let participant = controller {
        return participant.prepareForAppearingAnimation
      } else {
        return { }
      }
    }
  }
  
  var animateAppeared : (completed: Bool, completion: (didComplete :Bool) -> Void) -> Void {
    get {
      let controller = self.selectedViewController as? TransitionParticipant
      if let participant = controller {
        return participant.animateAppeared
      } else {
        return { (didComplete, completion) in completion(didComplete: didComplete) }
      }
    }
  }
  
  var animateDisappearing : (completion: (didComplete :Bool) -> Void) -> Void {
    get {
      let controller = self.selectedViewController as? TransitionParticipant
      if let participant = controller {
        return participant.animateDisappearing
      } else {
        return { (completion) in completion(didComplete: true) }
      }
    }
  }
  
  var resolveDisappearingAnimation : () -> Void {
    get {
      let controller = self.selectedViewController as? TransitionParticipant
      if let participant = controller {
        return participant.resolveDisappearingAnimation
      } else {
        return { }
      }
    }
  }
  
}