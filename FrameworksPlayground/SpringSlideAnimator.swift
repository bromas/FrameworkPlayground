//
//  SpringSlideAnimator.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Architect
import UIKit

enum SpringSlideDirection {
  case Right
  case Left
  case Up
  case Down
}

class SpringSlideAnimator : ParticipationAnimator {
  
  let slideDirection: SpringSlideDirection
  
  init(direction: SpringSlideDirection) {
    slideDirection = direction
    super.init()
    transitionDuration = 0.8
  }
  
  init(direction: SpringSlideDirection, duration: NSTimeInterval) {
    slideDirection = direction
    super.init()
    transitionDuration = duration
  }
  
  override func animateInternalTransition(transitionContext: UIViewControllerContextTransitioning, completion: (Bool) -> Void) {
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    let container = transitionContext.containerView()
    
    toView?.preppedForAutoLayout(inView: container)
    inset(toView!, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
    container.layoutIfNeeded()
    
    var toStartTransform: CGAffineTransform
    var fromTransform: CGAffineTransform
    switch slideDirection {
    case .Right:
      toStartTransform = CGAffineTransformMakeTranslation(container.bounds.width + 16, 0)
      fromTransform = CGAffineTransformMakeTranslation(-container.bounds.width - 16, 0)
    case .Left:
      toStartTransform = CGAffineTransformMakeTranslation(-container.bounds.width - 16, 0)
      fromTransform = CGAffineTransformMakeTranslation(container.bounds.width + 16, 0)
    case .Up:
      toStartTransform = CGAffineTransformMakeTranslation(0, -container.bounds.height - 16)
      fromTransform = CGAffineTransformMakeTranslation(0, container.bounds.height + 16)
    case .Down:
      toStartTransform = CGAffineTransformMakeTranslation(0, container.bounds.height + 16)
      fromTransform = CGAffineTransformMakeTranslation(0, -container.bounds.height - 16)
    }
    
    toView!.transform = toStartTransform
    
    let animations = { () -> Void in
      toView?.transform = CGAffineTransformIdentity
      fromView!.transform = fromTransform
    }
    
    UIView.animateWithDuration(self.transitionDuration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(0), animations: animations, completion: completion)
  }
  
  override func performInternalCompletion(transitionContext: UIViewControllerContextTransitioning) {
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    toView?.transform = CGAffineTransformIdentity
    fromView!.transform = CGAffineTransformIdentity
    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
  }
  
}