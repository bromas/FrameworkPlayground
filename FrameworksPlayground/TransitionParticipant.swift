//
//  TransitionParticipant.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/3/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TransitionParticipant : NSObjectProtocol {

  var prepareForAppearingAnimation : () -> Void { get }
  var animateAppeared : (completed: Bool, completion: (didComplete :Bool) -> Void) -> Void { get }
  var animateDisappearing : (completion: (didComplete :Bool) -> Void) -> Void { get }
  var resolveDisappearingAnimation : () -> Void { get }

}

