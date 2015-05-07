//
//  PhantomScrollController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/10/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

// TRASHBINNED over failure to pass touch events through phantom scroll like I had imagined.

import Foundation
import UIKit
import Architect
import ActivityViewController

class PhantomScrollController : ViewController, UIScrollViewDelegate {
  
  
  
  @IBOutlet var scroll: UIScrollView!
  
  var embedTopConstraint: NSLayoutConstraint!
  var containerView: UIView!
  var activeChildController: UIViewController?
  
  var childScroll: UIScrollView?
  var managedScroll: UIScrollView? {
    get {
      return childScroll
    }
    set {
      childScroll = newValue
    }
  }
  
  func childSizeChange(change: NSDictionary) {
    if let point : NSValue = change["new"] as? NSValue {
      if let loadedScroll = scroll {
//        scroll.contentSize = CGSizeMake(self.view.bounds.width, point.CGSizeValue().height + 400)
      }
    }
  }
  
  func setManagedScrollView(scroll: UIScrollView) {
    self.managedScroll = scroll
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.orangeColor()
    buildView()
    setActiveChildControllerTwo()
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if (scroll.contentOffset.y > 356) {
      embedTopConstraint.constant = 44
      childScroll?.setContentOffset(CGPoint(x: 0.0, y: scroll.contentOffset.y - 356), animated: false)
    } else {
      childScroll?.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
      embedTopConstraint.constant = 400 - scroll.contentOffset.y
    }
  }
  
  func setActiveChildControllerOne() {
    let childController = ScrollByPhantomController()
    childController.configureWithPhantomScrollController(self)
    Architect.embed(childController, withParent: self, inView: self.containerView) { controller in
      inset(controller.view, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
      return
    }
    self.scroll = childController.scroll
    self.activeChildController = childController
  }
  
  func setActiveChildControllerTwo() {
    let childController = TableViewWithModelAdditions()
    AppNetConfigurationManager.sharedInstance.configureSimpleSelectTable(childController)
    childController.configureWithPhantomScrollController(self)
    Architect.embed(childController, withParent: self, inView: self.containerView) { controller in
      inset(controller.view, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
      return
    }
    self.scroll = childController.table
    self.activeChildController = childController
  }
  
  func buildView() {
    
    self.containerView = Architect.view(inView: self.view) { [unowned self] view in
      inset(view, with: [.Right:0, .Left: 0])
      return
    }
    self.embedTopConstraint = NSLayoutConstraint(item: self.containerView, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 400.0)
    self.view.addConstraint(self.embedTopConstraint)
    
    Architect.view(inView: self.view) { [unowned self] in
      $0.backgroundColor = UIColor.blackColor()
      inset($0, with: [.Left: 0, .Right: 0])
      pin(bottom: $0, toTop: self.containerView, magnitude: 0.0)
      Constrain.size($0, with: [.Height: 44])
      Architect.button(type: UIButtonType.InfoDark, inView: $0) {
        $0.titleLabel?.text = "Hello"
        align(center: $0, with: [.X:-100, .Y:0])
        $0.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)
        return
      }
    }
    
    scroll = Architect.custom(UIScrollView(), inView: self.view) {
      $0.delegate = self
      inset($0, with: [.Right: 0, .Bottom: 0, .Left: 0])
      $0.contentSize = CGSizeMake(self.view.bounds.width, 2000)
    }
    self.view.addConstraint(NSLayoutConstraint(item: scroll, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    self.view.addConstraint(NSLayoutConstraint(item: self.containerView, attribute: .Height, relatedBy: .Equal, toItem: scroll, attribute: .Height, multiplier: 1.0, constant: -44))
  }
  
}