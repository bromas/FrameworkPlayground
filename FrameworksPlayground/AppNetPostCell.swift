//
//  AppNetPostCell.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/16/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import Architect
import BCCoalescing

class AppNetPostCell: UITableViewCell {
  
  var downloadToken: BCRegistrationToken?
  @IBOutlet var avatarView: UIImageView!
  @IBOutlet var userNameLabel: UILabel!
  @IBOutlet var postLabel: UILabel!
    
  var container: UIView!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.sharedInitializer()
  }
  
  func sharedInitializer() {
    
    // Avatar Icon View
    self.avatarView = Architect.imageView(inView: self.contentView) { [unowned self] in
      inset($0, with: [.Top: 8.0, .Left:8.0])
      size($0, with: [.Width: 60, .Height: 60])
      inset($0, withExtendedOptions: [.Bottom : (.GreaterThanOrEqual, 8.0, .Medium)])
      
      $0.layer.cornerRadius = 8.0
      $0.layer.masksToBounds = true
      $0.layer.borderWidth = 0.5
      $0.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    // Text Container View
    self.container = Architect.view(inView: self.contentView) { [unowned self] in
      inset($0, with: [.Top: 8, .Bottom: 8, .Right: 8])
      pin(left: $0, toRight: self.avatarView, magnitude: 8.0)
      
      self.userNameLabel = Architect.label(inView: $0) {
        inset($0, with: [.Top: 0, .Right: 0, .Left: 0])
        $0.font = UIFont.boldSystemFontOfSize(16)
      }
      self.userNameLabel.setContentCompressionResistancePriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
      self.layoutIfNeeded()
      
      self.postLabel = Architect.label(inView: $0) {
        inset($0, with: [.Right: 0, .Bottom: 0, .Left: 0])
        $0.font = UIFont.systemFontOfSize(14)
      }
      
      pin(top: self.postLabel, toBottom: self.userNameLabel, magnitude: 4.0)
    }
    
  }
  
  func updateAvatarIcon(image: UIImage?) -> Void {
    self.avatarView?.image = image
  }
  
  func updateAvatarIconAnimated(image: UIImage?) -> Void {
    UIView.animateWithDuration(0.2, animations: { () -> Void in
      self.avatarView.alpha = 0.0
      return
      }) { (completed) -> Void in
        self.avatarView?.image = image
        UIView.animateWithDuration(0.1, animations: { () -> Void in
          self.avatarView.alpha = 1.0
          return
        })
    }
  }
}
