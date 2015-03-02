//
//  PanSharingController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/9/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class PanSharingController : ViewController, UIScrollViewDelegate {
  
  var controllerSharingPanWith: PanSharingDelegate?
  var scroll: UIScrollView?
  
  func configureWithPanSharingDelegate(delegate: PanSharingDelegate) {
    controllerSharingPanWith = delegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    scroll = Architect.custom(UIScrollView(), inView: self.view) {
      Constrain.inset($0, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
      $0.backgroundColor = UIColor.darkGrayColor()
      $0.delegate = self
      Architect.view(inView: $0) {
        $0.backgroundColor = UIColor.redColor()
        Constrain.size($0, with: [.Width: 20, .Height: 1200])
        Constrain.inset($0, with: [.Top: 0, .Bottom: 0])
        $0.superview?.addConstraint(NSLayoutConstraint(item: $0, attribute: .CenterX, relatedBy: .Equal, toItem: $0.superview!, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        Architect.view(inView: $0) {
          $0.backgroundColor = UIColor.yellowColor()
          Constrain.size($0, with: [.Width: 20, .Height: 20])
          Constrain.center($0, with: [.Y: 0, .X: 0])
        }
      }
    }
    self.view.backgroundColor = UIColor.darkGrayColor()
    scroll?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if let hasShareDelegate = controllerSharingPanWith {
      let shouldScroll = hasShareDelegate.handleScrollViewDidScroll(scrollView)
      if !shouldScroll { } //scrollView.contentOffset = CGPointZero }
    }
  }
  
}
