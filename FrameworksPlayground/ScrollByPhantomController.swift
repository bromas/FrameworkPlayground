//
//  ScrollByPhantomController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/10/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class ScrollByPhantomController: ViewController {
  
  var phantomController: PhantomScrollController?
  @IBOutlet var scroll: UIScrollView!
  
  func configureWithPhantomScrollController(phantom: PhantomScrollController) {
    phantomController = phantom
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildView()
    phantomController?.setManagedScrollView(scroll)
  }
  
  func buildView() {
    scroll = Architect.custom(UIScrollView(), inView: self.view) {
      inset($0, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
      Architect.view(inView: $0){
        $0.backgroundColor = UIColor.redColor()
        size($0, with: [.Width: 20, .Height: 1200])
        inset($0, with: [.Top: 20, .Bottom: 20])
        $0.superview?.addConstraint(NSLayoutConstraint(item: $0, attribute: .CenterX, relatedBy: .Equal, toItem: $0.superview!, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        Architect.view(inView: $0) {
          $0.backgroundColor = UIColor.yellowColor()
          size($0, with: [.Width: 20, .Height: 20])
          align(center: $0, with: [.Y: 0, .X: 0])
        }
      }
    }
  }
  
}
