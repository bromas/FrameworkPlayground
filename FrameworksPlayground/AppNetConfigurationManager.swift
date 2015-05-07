//
//  AppNetConfigurationManager.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 5/5/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

private let _AppNetConfigurationManagerSharedInstance = AppNetConfigurationManager()

class AppNetConfigurationManager {
  class var sharedInstance: AppNetConfigurationManager {
    return _AppNetConfigurationManagerSharedInstance
  }
  
  var postDataProvider = AppNetPostRequestsManager()
  
  func configureSimpleSelectTable(table: TableViewWithModelG) {
    
    var configuration = CellNibConfiguration<AppNetPost>(identifier: "someCell", nib: UINib(nibName: "AppNetPost", bundle: NSBundle.mainBundle()))
    
    configuration.configureBlock = { [unowned self] cell, post in
      
      let appNetPostCell = cell as! AppNetPostCell
      appNetPostCell.userNameLabel.text = post.user.userName
      appNetPostCell.postLabel.text = post.text
      
      appNetPostCell.downloadToken?.invalidate()
      let image = self.postDataProvider.localImageForUser(post.user)
      switch image {
      case let .found(image):
        appNetPostCell.updateAvatarIcon(image)
      case let .mocked(image):
        appNetPostCell.updateAvatarIcon(image)
        
        let identifier = post.user.userName
        appNetPostCell.downloadToken = self.postDataProvider.downloadImageForUser(post.user) { downloadedImage in
          appNetPostCell.updateAvatarIconAnimated(downloadedImage)
        }
        
      }
    }
    
    let tableViewModel = PostTableViewModel<AppNetPost>()
    tableViewModel.registerCellConfiguration(configuration)
    tableViewModel.configureRequestsManager(postDataProvider)
    
    table.registerCellConfiguration(configuration)
    table.configure(viewModel: tableViewModel)
    
  }
  
}
