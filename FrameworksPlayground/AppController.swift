//
//  AppController.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class AppController: ActivityViewController {
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    super.prepareForSegue(segue, sender: sender)
  }
  
  override func prepareActivity(activity: String, controller: UIViewController) {
    switch activity {
    case "Launch":
      assert(true, "")
    case "Tables":
      ((controller as! UINavigationController).topViewController as! TablesIntroController).setStrategy(TablesIntroNavStrategy())
    default:
      assert(true, "")
    }
  }
}
