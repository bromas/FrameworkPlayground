//
//  SharePanController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/9/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect
import ActivityViewController

protocol PanSharingDelegate {
  func handleScrollViewDidScroll(scrollView: UIScrollView) -> Bool
}

class SharePanController : ViewController, PanSharingDelegate {
  
  @IBOutlet var swapButton: UIButton!
  var activities: ActivityViewController!
  var activeActivity: String = "posts"
  
  let lowPosition: CGFloat = 320.0
  let highPosition: CGFloat = 44.0
  
  var embedTopPin: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.orangeColor()
    
    let guide = Architect.view(inView: self.view) {
      inset($0, with: [.Right: 0, .Bottom: 0, .Left: 0])
      pin($0, edge: .Top, toGuide: self.topLayoutGuide, inController: self, constant: self.highPosition)
      $0.backgroundColor = UIColor.clearColor()
    }
    
    activities = ActivityViewController()
    self.configureEmbeddedActivities(activities)
    let embed = Architect.embed(activities, withParent: self, inView: self.view) {
      self.embedTopPin = pin($0.view, edge: .Top, toGuide: self.topLayoutGuide, inController: self, constant: self.lowPosition)
      inset($0.view, with: [.Right:0, .Left: 0])
      equate($0.view, to: guide, with: [.Height: 0])
    }
    
    self.swapButton = Architect.button(type: UIButtonType.System, inView: self.view) {
      align(center: $0, with: [.X: 0])
      pin(bottom: $0, toTop: embed.view, magnitude: -8.0)
      $0.addTarget(self, action: "swapController", forControlEvents: UIControlEvents.TouchUpInside)
      $0.setTitle("Swap", forState: UIControlState.Normal)
    }
  }
  
  func swapController() {
//    I'm flushing the inactive identifiers until I figure out the proper way to handle the scrolling delegate - this isn't the intended final behavior
    self.swapButton.enabled = false
    switch activeActivity {
    case "posts":
      var operation = ActivityOperation(identifier: "scroll", animator: SpringSlideAnimator(direction: .Right))
      operation.completionBlock = { [unowned self] in
        self.swapButton.enabled = true
        self.activities.flushInactiveActivitiesForIdentifier("posts")
        return
      }
      activities.performActivityOperation(operation)
      activeActivity = "scroll"
    default:
      var operation = ActivityOperation(identifier: "posts", animator: SpringSlideAnimator(direction: .Left))
      operation.completionBlock = { [unowned self] in
        self.swapButton.enabled = true
        self.activities.flushInactiveActivitiesForIdentifier("scroll")
        return
      }
      activities.performActivityOperation(operation)
      activeActivity = "posts"
    }
  }

  func configureEmbeddedActivities(activities: ActivityViewController) {
    
    activities.registerGenerator("posts") { [unowned self] () -> UIViewController in
      let childController = TableViewWithModelAdditions()
      AppNetConfigurationManager.sharedInstance.configureSimpleSelectTable(childController)
      childController.configureWithPanSharingDelegate(self)
      return childController
    }
    
    activities.registerGenerator("scroll") { [unowned self] () -> UIViewController in
      let childController = TableViewWithModelAdditions()
      AppNetConfigurationManager.sharedInstance.configureSimpleSelectTable(childController)
      childController.configureWithPanSharingDelegate(self)
      return childController
    }
    
    activities.initialActivityIdentifier = "posts"
  }
  
  
  func handleScrollViewDidScroll(scrollView: UIScrollView) -> Bool {
    if scrollView.contentOffset.y == 0 {
      scrollView.showsVerticalScrollIndicator = false
      return true
    } else if scrollView.contentOffset.y > 0 {
      if self.embedTopPin!.constant > highPosition {
        // Adjust
        let adjustAmount = 1.4  * scrollView.contentOffset.y
        self.embedTopPin!.constant -= adjustAmount
        scrollView.contentOffset = CGPointZero
        // Limit
        if self.embedTopPin!.constant < highPosition { self.embedTopPin!.constant = highPosition }
        // We moved - You don't move
        return false
      } else {
        scrollView.showsVerticalScrollIndicator = true
        return true
      }
    } else {
      if self.embedTopPin!.constant < lowPosition {
        // Adjust
        let adjustAmount = 0.4 * scrollView.contentOffset.y
        self.embedTopPin!.constant -= adjustAmount
        // Limit
        if self.embedTopPin!.constant > lowPosition { self.embedTopPin!.constant = lowPosition }
        // We moved - You don't move
        return false
      } else {
        if scrollView.contentOffset.y < 0 {
          scrollView.showsVerticalScrollIndicator = false
          return false
        }
        else {
          scrollView.showsVerticalScrollIndicator = true
          return true
        }
      }
    }
  }
}
