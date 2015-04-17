//
//  BackInNavStrategy.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import StrategicControllers

typealias TablesIntroNavStrategy = tablesIntroNavStrategy<Int>
class tablesIntroNavStrategy<Int> : ControllerStrategy<TablesIntroController> {
  
  var postDataProvider = AppNetPostRequestsManager()
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "TableWithModel" {
      let tableViewWithModel = segue.destinationViewController as! TableViewWithModelG
      tableViewWithModel.setStrategy(TableWithVMTablesStrategy())
      
      var configuration = CellNibConfiguration<AppNetPost>(identifier: "someCell", nib: UINib(nibName: "AppNetPost", bundle: NSBundle.mainBundle()))
      
      configuration.configureBlock = { [unowned self] cell, post in
        
        let appNetPostCell = cell as! AppNetPostCell
        appNetPostCell.userNameLabel.text = post.user.userName
        appNetPostCell.postLabel.text = post.text
        
        appNetPostCell.imageFilter = { identifier in
          return post.user.userName == identifier
        }
        
        let image = self.postDataProvider.localImageForUser(post.user)
        switch image {
        case let .found(image):
          appNetPostCell.updateAvatarIcon(image)
        case let .mocked(image):
          appNetPostCell.updateAvatarIcon(image)
          
          let identifier = post.user.userName
          self.postDataProvider.downloadImageForUser(post.user) { downloadedImage in
            appNetPostCell.updateAvatarIconWithCheck(downloadedImage, filterIdentifier: identifier)
          }
          
        }
      }
      
      let tableViewModel = PostTableViewModel<AppNetPost>()
      tableViewModel.registerCellConfiguration(configuration)
      
      tableViewWithModel.registerCellConfiguration(configuration)
      tableViewWithModel.configure(viewModel: tableViewModel)
    }
  }
  
  override func viewDidLoad() {
    controller.prepareForAppearingAnimation = { [unowned self] (completion) in
      let animation = CAColorAnimation("backgroundColor", from: UIColor.redColor(), to: UIColor.blackColor(), 0.7)
      self.controller.underView.layer.addAnimation(animation, forKey: "backgroundColorChange")
      self.controller.underView.backgroundColor = UIColor.blackColor()
    }
    
    controller.animateAppeared = { [unowned self] (completed, completion) in
      CATransaction.begin()
      CATransaction.setCompletionBlock() {
        completion(didComplete: completed)
      }
      CATransaction.setAnimationDuration(0.2)
      let animation = CAColorAnimation("backgroundColor", from: UIColor.blackColor(), to: UIColor.whiteColor(), 0.2)
      self.controller.underView.layer.addAnimation(animation, forKey: "backgroundColorChange")
      CATransaction.commit()
      
      self.controller.underView.backgroundColor = UIColor.whiteColor()
    }
  }
  
}
