//
//  ParticipationAnimator.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class ParticipationAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  
  var transitionDuration: NSTimeInterval = 0.4
  
  final func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return transitionDuration
  }
  
  final func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? TransitionParticipant
    let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? TransitionParticipant
    
    let completion : (Bool) -> Void = { (didComplete) in
      if let toParticipant = toController {
        self.performInternalCompletion(transitionContext)
        if let fromParticipant = fromController {
          fromParticipant.resolveDisappearingAnimation()
        }
        toParticipant.animateAppeared(completed: didComplete) { (completed) in }
      } else {
        self.performInternalCompletion(transitionContext)
        if let fromParticipant = fromController {
          fromParticipant.resolveDisappearingAnimation()
        }
//        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      }
    }
    
    if let fromParticipant = fromController {
      fromParticipant.animateDisappearing { (didComplete) in
        if let toParticipant = toController {
          toParticipant.prepareForAppearingAnimation()
        }
        self.animateInternalTransition(transitionContext, completion: completion)
      }
    } else {
      if let toParticipant = toController {
        toParticipant.prepareForAppearingAnimation()
      }
      self.animateInternalTransition(transitionContext, completion: completion)
    }
  }
  
  func animateInternalTransition(transitionContext: UIViewControllerContextTransitioning, completion: ((Bool) -> Void)) -> Void {
    
  }
  
  func performInternalCompletion(transitionContext: UIViewControllerContextTransitioning) {
    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
  }
  
}