//
//  TableViewWithModelAdditions.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/11/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class TableViewWithModelAdditions: TableViewWithModelG, TransitionParticipant {
  
  var phantomController: PhantomScrollController?
  var controllerSharingPanWith: PanSharingDelegate?
  
  func configureWithPhantomScrollController(phantom: PhantomScrollController) {
    phantomController = phantom
  }
  
  func configureWithPanSharingDelegate(delegate: PanSharingDelegate) {
    controllerSharingPanWith = delegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    phantomController?.setManagedScrollView(self.table)
    self.table.decelerationRate = UIScrollViewDecelerationRateNormal
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if let hasShareDelegate = controllerSharingPanWith {
      let shouldScroll = hasShareDelegate.handleScrollViewDidScroll(scrollView)
      if !shouldScroll { } //scrollView.contentOffset = CGPointZero }
    }
  }
  
  var prepareForAppearingAnimation : () -> Void = { () -> Void in }
  var animateAppeared : (completed: Bool, completion: (didComplete :Bool) -> Void) -> Void = { (completed, completion) in
    completion(didComplete: completed)
  }
  
  var animateDisappearing : (completion: (didComplete :Bool) -> Void) -> Void = { (completion) -> Void in
    completion(didComplete: true)
  }
  var resolveDisappearingAnimation : () -> Void = { () in }
  
}
