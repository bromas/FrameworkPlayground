//
//  ScrollGrowController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/6/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect

class ScrollGrowController: ViewController {
  
  var observer: FBKVOController = FBKVOController()
  @IBOutlet var scrollView: UIScrollView!
  
  weak var weakSelf : ScrollGrowController?
  
  let minimumImageHeight :CGFloat = 200
  @IBOutlet weak var imageHeight: NSLayoutConstraint!
  @IBOutlet weak var imageOffset: NSLayoutConstraint!
  
  deinit { }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildView()
    observer = FBKVOController(observer: self)
    observer.observe(scrollView, keyPath: "contentOffset", options: .Initial | .New, action: "scrollChange:")
  }
  
  // This should just be done by scrollViewDidScroll yea?
  func scrollChange(change: NSDictionary) {
    if let point : NSValue = change["new"] as? NSValue {
      let offset = self.minimumImageHeight - point.CGPointValue().y
      if (offset > self.minimumImageHeight) {
        self.imageHeight.constant = CGFloat(offset)
        self.imageOffset.constant = 0.0
      } else {
        self.imageHeight.constant = CGFloat(self.minimumImageHeight)
        let offsetAdjusted = offset - self.minimumImageHeight
        self.imageOffset.constant = CGFloat(offsetAdjusted*0.1)
      }
    }
  }
  
  func buildView() {
    // Background imageView
    Architect.view(inView: self.view) { [unowned self] in
      $0.backgroundColor = UIColor.greenColor()
      self.imageOffset = NSLayoutConstraint(item: $0, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
      self.view.addConstraint(self.imageOffset)
      align(center: $0, with: [.X: 0])
      self.imageHeight =  size($0, with: [.Height: self.minimumImageHeight])[.Height]!
      $0.addConstraint(NSLayoutConstraint(item: $0, attribute: .Width, relatedBy: .Equal, toItem: $0, attribute: .Height, multiplier: 1.0, constant: 0.0))
    }
    
// ScrollView as sibling / over top of image
    let view = Architect.custom(UIScrollView(), inView: self.view) { (scroll) in
      scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      scroll.backgroundColor = UIColor.clearColor()
      inset(scroll, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
// Red line in scroll view to constrain height
      Architect.view(inView: scroll) {
        $0.backgroundColor = UIColor.redColor()
        inset($0, with: [.Top:300, .Bottom: 0])
        align(center: $0, with: [.X: 0])
        size($0, with: [.Width: 20, .Height: 1300])
// Yellow square in Red Line to mark where you are in scroll
        Architect.view(inView: $0) {
          $0.backgroundColor = UIColor.yellowColor()
          align(center: $0, with: [.X: 0, .Y: 0])
          size($0, with: [.Width: 10, .Height: 10])
        }
      }
    }
    scrollView = view
  }
}