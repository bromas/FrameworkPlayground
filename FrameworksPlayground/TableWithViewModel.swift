//
//  TableWithViewModel.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 3/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import StrategicControllers
import Architect

class TableViewWithModel : StrategicController, UITableViewDataSource, UITableViewDelegate {
  
  @IBAction func tempButtonTap() { actionOnTempButtonTap() }
  var actionOnTempButtonTap : () -> Void = {
    
  }
  
  @IBAction func buttonTap() { actionOnSelection(viewModel: self.viewModel!, indexPath: self.table.indexPathForSelectedRow()!.row) }
  var actionOnSelection : (viewModel: TableViewModel, indexPath: Int) -> Void = { (tableViewModel, index) in
    
  }
  
  @IBOutlet var table: UITableView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  var viewModel: TableViewModel?
  var cellIdentifier: String = "cellIdentifier"
  
  func configure(#viewModel: TableViewModel) {
    self.viewModel = viewModel
    if self.isViewLoaded() {
      table.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let foundTable = table {
      cellIdentifier = viewModel?.registerTableViewCell(self.table) ?? "cellIdentifier"
    } else {
      self.table = Architect.custom(UITableView(), inView: self.view) {
        Constrain.inset($0, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
        return
      }
      cellIdentifier = viewModel?.registerTableViewCell(self.table) ?? "cellIdentifier"
      self.table.delegate = self
      self.table.dataSource = self
    }
    self.table.rowHeight = UITableViewAutomaticDimension
    self.table.estimatedRowHeight = viewModel?.estimatedRowHeight() ?? 60.0
    self.table.allowsSelection = true
    self.table.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 1))
    self.activityIndicator = Architect.custom(UIActivityIndicatorView(activityIndicatorStyle: .Gray), inView: self.view) {
      Constrain.center($0, with: [.X: 0, .Y: -100])
      $0.hidesWhenStopped = true
      $0.startAnimating()
    }
    self.viewModel?.refreshData() { [unowned self] () -> Void in
      self.table.reloadData()
      self.activityIndicator.stopAnimating()
    }
  }
  
  // Data Source
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.numberOfItems() ?? 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? UITableViewCell ?? UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
    viewModel?.configureCell(cell, forIndexPath: indexPath.row)
    cell.frame =  CGRectMake(0, 0, CGRectGetWidth(self.table.frame), 90)
    cell.layoutIfNeeded()
    return cell
  }
  
}
