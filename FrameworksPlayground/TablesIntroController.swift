//
//  BackController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ApplicationViewController
import StrategicControllers
import Alamofire
import Runes

class TablesIntroController: ViewController {
  
  @IBOutlet var underView: UIView!
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    switch CGFloat(arc4random()) % 2 {
    case 0:
      ActivityOperation(identifier: "List", animator: OpenAndThroughAnimator(open: .Vertical, direction: .Out, duration: 0.8)).execute()
    default:
      ActivityOperation(identifier: "List", animator: OpenAndThroughAnimator(open: .Horizontal, direction: .Out, duration: 0.8)).execute()
    }
  }
  
  @IBAction func backButtonTap() { actionOnBackButtonTap() }
  var actionOnBackButtonTap : () -> Void = {
    ActivityOperation(identifier: "Intro", animator: SpringSlideAnimator(direction: .Left)).execute()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}