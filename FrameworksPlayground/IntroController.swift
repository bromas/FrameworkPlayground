//
//  DemoController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import ApplicationViewController
import StrategicControllers

class IntroController: ViewController {
  
  @IBOutlet var button: UIView!
  @IBOutlet var hereLabel: UILabel!
  @IBOutlet var weLabel: UILabel!
  @IBOutlet var goLabel: UILabel!

  @IBOutlet var circleControl: UIControl!
  @IBOutlet var squareControl: UIControl!
  @IBOutlet var triangleControl: UIControl!
  @IBOutlet var triangleHeight: NSLayoutConstraint!
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    ActivityOperation(identifier: "Tables", animator: SpringSlideAnimator(direction: .Right)).execute()
    return
  }
  
  @IBAction func dynamicsButtonTap() { actionOnDynamicsButtonTap() }
  var actionOnDynamicsButtonTap : () -> Void = {
    ActivityOperation(identifier: "Dynamic", animator: SpringSlideAnimator(direction: .Right)).execute()
    return
  }
  
  @IBAction func gesturesTap() { actionOnGesturesTap() }
  var actionOnGesturesTap : () -> Void = {
    ActivityOperation(identifier: "Gestures", animator: SpringSlideAnimator(direction: .Right)).execute()
    return
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerAnimations()
    (self.squareControl as! SquareButton).actionLabel.text = "Scrolling"
    (self.triangleControl as! TriangleButton).actionLabel.text = "Dynamics"
    (self.circleControl as! CircleButton).actionLabel.text = "Example"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func registerAnimations() {
    
    prepareForAppearingAnimation = {
      self.triangleControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
      self.triangleControl.alpha = 0.0
      self.squareControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
      self.squareControl.alpha = 0.0
      self.circleControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
      self.circleControl.alpha = 0.0
    }
    
    animateAppeared = { (completionBlock) in
      
      let triangleAnimation = { () -> Void in
        self.triangleControl.transform = CGAffineTransformIdentity
        self.triangleControl.alpha = 1.0
      }
      
      let squareAnimation = { () -> Void in
        self.squareControl.transform = CGAffineTransformIdentity
        self.squareControl.alpha = 1.0
      }
      
      let circleAnimation = { () -> Void in
        self.circleControl.transform = CGAffineTransformIdentity
        self.circleControl.alpha = 1.0
      }
      
      let completion = { (completed: Bool) -> Void in
        return
      }
      
      var randomNumber = (Double(arc4random()) % 3) / 10
      UIView.animateWithDuration(0.5, delay: randomNumber, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.45, options: UIViewAnimationOptions(0), animations: triangleAnimation, completion: completion)
      
      randomNumber = (Double(arc4random()) % 3) / 10
      UIView.animateWithDuration(0.6, delay: randomNumber, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.45, options: UIViewAnimationOptions(0), animations: circleAnimation, completion: completion)
      
      randomNumber = (Double(arc4random()) % 3) / 10
      UIView.animateWithDuration(0.6, delay: randomNumber, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.45, options: UIViewAnimationOptions(0), animations: squareAnimation, completion: completion)

    }
    
    animateDisappearing = { (completion) in
      let animations = { () -> Void in
        var randomNumber = (Double(arc4random()) % 5) / 10
        UIView.addKeyframeWithRelativeStartTime(randomNumber, relativeDuration: 0.5, animations: { () -> Void in
          self.triangleControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
          self.triangleControl.alpha = 0.0
        })
        randomNumber = (Double(arc4random()) % 5) / 10
        UIView.addKeyframeWithRelativeStartTime(randomNumber, relativeDuration: 0.5, animations: { () -> Void in
          self.squareControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
          self.squareControl.alpha = 0.0
        })
        randomNumber = (Double(arc4random()) % 5) / 10
        UIView.addKeyframeWithRelativeStartTime(randomNumber, relativeDuration: 0.5, animations: { () -> Void in
          self.circleControl.transform = CGAffineTransformMakeScale(0.1, 0.1)
          self.circleControl.alpha = 0.0
        })
      }
      let completion = { (completed: Bool) -> Void in
        completion(didComplete: completed)
      }
      UIView.animateKeyframesWithDuration(0.5, delay: 0.0, options: UIViewKeyframeAnimationOptions(0), animations: animations, completion: completion)
    }
    
    resolveDisappearingAnimation = {
      self.triangleControl.transform = CGAffineTransformIdentity
      self.squareControl.transform = CGAffineTransformIdentity
      self.circleControl.transform = CGAffineTransformIdentity
    }
    
  }
  
}