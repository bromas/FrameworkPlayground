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
import ApplicationViewController

protocol PanSharingDelegate {
  func handleScrollViewDidScroll(scrollView: UIScrollView) -> Bool
}

class SharePanController : ViewController, PanSharingDelegate {
  
  let lowPosition: CGFloat = 320.0
  let highPosition: CGFloat = 44.0
  
  var embedTopConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.automaticallyAdjustsScrollViewInsets = false
    self.view.backgroundColor = UIColor.orangeColor()
    
    let guide = Architect.view(inView: self.view) {
      Constrain.inset($0, with: [.Right: 0, .Bottom: 0, .Left: 0])
      self.view.addConstraint(NSLayoutConstraint(item: $0, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
      $0.backgroundColor = UIColor.clearColor()
    }
    
    let childController = TableViewWithModelAdditions()
    childController.configure(viewModel: PostTableViewModel())
    childController.configureWithPanSharingDelegate(self)
    Architect.embed(childController, withParent: self, inView: self.view) { [unowned self] controller in
      self.embedTopConstraint = NSLayoutConstraint(item: childController.view, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: self.lowPosition)
      self.view.addConstraint(self.embedTopConstraint!)
      Constrain.inset(controller.view, with: [.Right:0, .Left: 0])
      self.view.addConstraint(NSLayoutConstraint(item: controller.view, attribute: .Height, relatedBy: .Equal, toItem: guide, attribute: .Height, multiplier: 1.0, constant: -44.0))
    }
  }

  
  func handleScrollViewDidScroll(scrollView: UIScrollView) -> Bool {
    if scrollView.contentOffset.y == 0 {
      scrollView.showsVerticalScrollIndicator = false
      return true
    } else if scrollView.contentOffset.y > 0 {
      if self.embedTopConstraint!.constant > highPosition {
        // Adjust
        let adjustAmount = 1.4  * scrollView.contentOffset.y
        self.embedTopConstraint!.constant -= adjustAmount
        scrollView.contentOffset = CGPointZero
        // Limit
        if self.embedTopConstraint!.constant < highPosition { self.embedTopConstraint!.constant = highPosition }
        // We moved - You don't move
        return false
      } else {
        scrollView.showsVerticalScrollIndicator = true
        return true
      }
    } else {
      if self.embedTopConstraint!.constant < lowPosition {
        // Adjust
        let adjustAmount = 0.4 * scrollView.contentOffset.y
        self.embedTopConstraint!.constant -= adjustAmount
        // Limit
        if self.embedTopConstraint!.constant > lowPosition { self.embedTopConstraint!.constant = lowPosition }
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
