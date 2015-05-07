//
//  OpenAndThroughAnimator.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import Architect
import UIKit

enum OpenDirection {
  case Vertical
  case Horizontal
}

enum ThroughDirection {
  case In
  case Out
}

typealias SolutionsTuple =
  (toVST: CGAffineTransform, toVET: CGAffineTransform,
  fromVST: CGAffineTransform, fromVET: CGAffineTransform,
  oneSplit: UIView, twoSplit: UIView,
  oneSplitST: CGAffineTransform, twoSplitST: CGAffineTransform,
  oneSplitET: CGAffineTransform, twoSplitET: CGAffineTransform)

class OpenAndThroughAnimator : ParticipationAnimator {
  
  let openDirection: OpenDirection
  let throughDirection: ThroughDirection
  var solution : SolutionsTuple?
  var toV : UIView?
  var fromV : UIView?
  
  init(open: OpenDirection) {
    openDirection = open
    throughDirection = .In
    super.init()
    transitionDuration = 0.8
  }
  
  init(open: OpenDirection, direction: ThroughDirection, duration: NSTimeInterval) {
    openDirection = open
    throughDirection = direction
    super.init()
    transitionDuration = duration
  }
  
  override func animateInternalTransition(transitionContext: UIViewControllerContextTransitioning, completion: ((Bool) -> Void)) -> Void {
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    let container = transitionContext.containerView()
    toV = toView
    fromV = fromView
    
    toView?.preppedForAutoLayout(inView: container)
    inset(toView!, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
    container.sendSubviewToBack(toView!)
    container.layoutIfNeeded()
    
    var solution : SolutionsTuple
    var configuration : () -> Void
    var animations : () -> Void
    
    switch openDirection {
    case .Horizontal where throughDirection == .In:
      solution =  horizontalInSplitsAndTransforms(container, fromView: fromView!)
    case .Horizontal where throughDirection == .Out:
      solution =  horizontalOutSplitsAndTransforms(container, toView: toView!)
    case .Vertical where throughDirection == .In:
      solution =  verticalInSplitsAndTransforms(container, fromView: fromView!)
    case .Vertical where throughDirection == .Out:
      solution =  verticalOutSplitsAndTransforms(container, toView: toView!)
    default:
      solution =  horizontalInSplitsAndTransforms(container, fromView: fromView!)
    }
    
    switch throughDirection {
    case .In:
      configuration = inConfiguration(solution, toView: toView!, fromView: fromView!)
      animations = inAnimations(solution, toView: toView!, fromView: fromView!)
    case .Out:
      configuration = outConfiguration(solution, toView: toView!, fromView: fromView!)
      animations = outAnimations(solution, toView: toView!, fromView: fromView!)
    }
    
    configuration()
    
    UIView.animateKeyframesWithDuration(0.8, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: animations, completion: completion)
  }
  
  override func performInternalCompletion(transitionContext: UIViewControllerContextTransitioning) {
    switch throughDirection {
    case .In:
      self.toV!.alpha = 1.0
      self.fromV!.alpha = 1.0
      self.solution!.oneSplit.removeFromSuperview()
      self.solution!.twoSplit.removeFromSuperview()
      self.toV!.layoutIfNeeded()
      self.fromV!.layoutIfNeeded()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    case .Out:
      self.toV!.alpha = 1.0
      self.fromV!.alpha = 1.0
      self.fromV!.transform = CGAffineTransformIdentity
      self.solution!.oneSplit.removeFromSuperview()
      self.solution!.twoSplit.removeFromSuperview()
      self.toV!.layoutIfNeeded()
      self.fromV!.layoutIfNeeded()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
  }
  
  func animationEnded(transitionCompleted: Bool) {
    
  }
  
  func horizontalInSplitsAndTransforms(container: UIView, fromView: UIView) -> SolutionsTuple {
    let images = horizontalSplits(fromView)
    var firstSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.left
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Left: 0, .Top: 0, .Bottom: 0])
      size(imageView, with: [.Width: container.bounds.width/2])
    }
    var secondSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.right
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Right: 0, .Top: 0, .Bottom: 0])
      size(imageView, with: [.Width: container.bounds.width/2])
    }
    container.layoutIfNeeded()
    let firstSplitFromTransform = CGAffineTransformIdentity
    let firstSplitToTransform = CGAffineTransformMakeTranslation(-container.bounds.width/2, 0)
    let secondSplitFromTransform = CGAffineTransformIdentity
    let secondSplitToTransform = CGAffineTransformMakeTranslation(container.bounds.width/2, 0)
    let fromStartTransform = CGAffineTransformIdentity
    let fromEndTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toStartTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toEndTransform = CGAffineTransformIdentity
    solution = (toStartTransform, toEndTransform, fromStartTransform, fromEndTransform, firstSplit, secondSplit, firstSplitFromTransform, secondSplitFromTransform, firstSplitToTransform, secondSplitToTransform)
    return solution!
  }
  
  func verticalInSplitsAndTransforms(container: UIView, fromView: UIView) -> SolutionsTuple {
    let images = verticalSplits(fromView)
    var firstSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.top
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Left: 0, .Top: 0, .Right: 0])
      size(imageView, with: [.Height: container.bounds.height/2])
    }
    var secondSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.bottom
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Left: 0, .Bottom: 0, .Right: 0])
      size(imageView, with: [.Height: container.bounds.height/2])
    }
    container.layoutIfNeeded()
    let firstSplitFromTransform = CGAffineTransformIdentity
    let firstSplitToTransform = CGAffineTransformMakeTranslation(0, -container.bounds.height/2)
    let secondSplitFromTransform = CGAffineTransformIdentity
    let secondSplitToTransform = CGAffineTransformMakeTranslation(0, container.bounds.height/2)
    let fromStartTransform = CGAffineTransformIdentity
    let fromEndTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toStartTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toEndTransform = CGAffineTransformIdentity
    solution = (toStartTransform, toEndTransform, fromStartTransform, fromEndTransform, firstSplit, secondSplit, firstSplitFromTransform, secondSplitFromTransform, firstSplitToTransform, secondSplitToTransform)
    return solution!
  }
  
  func inConfiguration(solution: SolutionsTuple, toView: UIView, fromView: UIView) -> () -> Void {
    return {
      fromView.alpha = 0.0
      toView.alpha = 0.4
      toView.transform = solution.toVST
    }
  }
  
  func inAnimations(solution: SolutionsTuple, toView: UIView, fromView: UIView) -> () -> Void {
    return { () -> Void in
      UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.8, animations: { () in
        toView.transform = solution.toVET
        toView.alpha = 1.0
      })
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.45, animations: { () in
        solution.oneSplit.transform = solution.oneSplitET
        solution.twoSplit.transform = solution.twoSplitET
      })
    }
  }
  
  func inCompletion(solution: SolutionsTuple, toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) -> (Bool) -> Void {
    return { (didComplete) in
      self.toV!.alpha = 1.0
      self.fromV!.alpha = 1.0
      self.solution!.oneSplit.removeFromSuperview()
      self.solution!.twoSplit.removeFromSuperview()
      self.toV!.layoutIfNeeded()
      self.fromV!.layoutIfNeeded()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      return
    }
  }
  
  func verticalOutSplitsAndTransforms(container: UIView, toView: UIView) -> SolutionsTuple {
    let images = verticalSplits(toView)
    var firstSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.top
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Left: 0, .Top: 0, .Right: 0])
      size(imageView, with: [.Height: container.bounds.height/2])
    }
    var secondSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.bottom
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Right: 0, .Bottom: 0, .Left: 0])
      size(imageView, with: [.Height: container.bounds.height/2])
    }
    container.layoutIfNeeded()
    let firstSplitFromTransform = CGAffineTransformMakeTranslation(0, -container.bounds.height/2)
    let firstSplitToTransform = CGAffineTransformIdentity
    let secondSplitFromTransform = CGAffineTransformMakeTranslation(0, container.bounds.height/2)
    let secondSplitToTransform = CGAffineTransformIdentity
    let fromStartTransform = CGAffineTransformIdentity
    let fromEndTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toStartTransform = CGAffineTransformIdentity
    let toEndTransform = CGAffineTransformIdentity
    solution = (toStartTransform, toEndTransform, fromStartTransform, fromEndTransform, firstSplit, secondSplit, firstSplitFromTransform, secondSplitFromTransform, firstSplitToTransform, secondSplitToTransform)
    return solution!
  }
  
  func horizontalOutSplitsAndTransforms(container: UIView, toView: UIView) -> SolutionsTuple {
    let images = horizontalSplits(toView)
    var firstSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.left
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Left: 0, .Top: 0, .Bottom: 0])
      size(imageView, with: [.Width: container.bounds.width/2])
    }
    var secondSplit = Architect.imageView(inView: container) { (imageView) in
      imageView.image = images.right
      imageView.backgroundColor = UIColor.greenColor()
      inset(imageView, with: [.Right: 0, .Top: 0, .Bottom: 0])
      size(imageView, with: [.Width: container.bounds.width/2])
    }
    container.layoutIfNeeded()
    let firstSplitFromTransform = CGAffineTransformMakeTranslation(-container.bounds.width/2, 0)
    let firstSplitToTransform = CGAffineTransformIdentity
    let secondSplitFromTransform = CGAffineTransformMakeTranslation(container.bounds.width/2, 0)
    let secondSplitToTransform = CGAffineTransformIdentity
    let fromStartTransform = CGAffineTransformIdentity
    let fromEndTransform = CGAffineTransformMakeScale(0.8, 0.8)
    let toStartTransform = CGAffineTransformIdentity
    let toEndTransform = CGAffineTransformIdentity
    solution = (toStartTransform, toEndTransform, fromStartTransform, fromEndTransform, firstSplit, secondSplit, firstSplitFromTransform, secondSplitFromTransform, firstSplitToTransform, secondSplitToTransform)
    return solution!
  }
  
  func outConfiguration(solution: SolutionsTuple, toView: UIView, fromView: UIView) -> () -> Void {
    return {
      toView.alpha = 0.0
      toView.transform = solution.toVST
      solution.oneSplit.transform = solution.oneSplitST
      solution.twoSplit.transform = solution.twoSplitST
    }
  }
  
  func outAnimations(solution: SolutionsTuple, toView: UIView, fromView: UIView) -> () -> Void {
    return { () -> Void in
      UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.8, animations: { () in
        fromView.transform = solution.fromVET
        fromView.alpha = 0.4
      })
      UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.45, animations: { () in
        solution.oneSplit.transform = solution.oneSplitET
        solution.twoSplit.transform = solution.twoSplitET
      })
    }
  }
  
  func outCompletion(solution: SolutionsTuple, toView: UIView, fromView: UIView, transitionContext: UIViewControllerContextTransitioning) -> (Bool) -> Void {
    return { (didComplete) in
      self.toV!.alpha = 1.0
      self.fromV!.alpha = 1.0
      self.fromV!.transform = CGAffineTransformIdentity
      self.solution!.oneSplit.removeFromSuperview()
      self.solution!.twoSplit.removeFromSuperview()
      self.toV!.layoutIfNeeded()
      self.fromV!.layoutIfNeeded()
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      return
    }
  }
  
}