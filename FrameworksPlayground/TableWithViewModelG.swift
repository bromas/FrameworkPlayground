//
//  TableWithViewModelG.swift
//  FrameworksPlayground
//
//  Created by Brian Thomas on 4/15/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import StrategicControllers
import Architect

class TableViewWithModelG : StrategicController, UITableViewDelegate, UITableViewDataSource {
  
  @IBAction func tempButtonTap() { actionOnTempButtonTap() }
  var actionOnTempButtonTap : () -> Void = {
    
  }
  
  @IBAction func cellSelectedByTap() {
    actionOnSelection(viewModel: self.viewModel,
      cell: self.table.cellForRowAtIndexPath(self.table.indexPathForSelectedRow()!)!,
      indexPath: self.table.indexPathForSelectedRow()!.row)
  }
  
  var actionOnSelection : (viewModel: TableViewModel?, cell: UITableViewCell, indexPath: Int) -> Void = { (tableViewModel, cell, index) in
    
  }
  
  @IBOutlet var table: UITableView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  var viewModel: TableViewModel?
  var cellIdentifier: String = "cellIdentifier"
  var cellConfiguration: CellRegistrationConfiguration?
  
  func configure(#viewModel: TableViewModel) {
    self.viewModel = viewModel
    if self.isViewLoaded() {
      table.reloadData()
    }
  }
  
  func registerCellConfiguration(model: CellRegistrationConfiguration) {
    cellConfiguration = model
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let foundTable = table {
      cellIdentifier = cellConfiguration?.registerToTable(foundTable) ?? "cellIdentifer"
    } else {
      self.table = Architect.custom(UITableView(), inView: self.view) {
        Constrain.inset($0, with: [.Top: 0, .Right: 0, .Bottom: 0, .Left: 0])
        return
      }
      cellIdentifier = cellConfiguration?.registerToTable(self.table) ?? "cellIdentifer"
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
    viewModel?.configureCell(cell, identifier: cellIdentifier, forIndexPath: indexPath.row)
    cell.frame =  CGRectMake(0, 0, CGRectGetWidth(self.table.frame), 90)
    cell.layoutIfNeeded()
    return cell
  }
  
}