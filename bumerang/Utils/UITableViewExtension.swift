//
//  TableViewExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

public extension UITableView {
    
//    func registerCellClass(_ cellClass: AnyClass) {
//        let identifier = String.className(cellClass)
//        self.register(cellClass, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerCellNib(_ cellClass: AnyClass) {
//        let identifier = String.className(cellClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forCellReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
//        let identifier = String.className(viewClass)
//        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
//    }
//    
//    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
//        let identifier = String.className(viewClass)
//        let nib = UINib(nibName: identifier, bundle: nil)
//        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
//    }
    
    func scroll(to: Position, animated: Bool) {
      let sections = numberOfSections
      let rows = numberOfRows(inSection: numberOfSections - 1)
      switch to {
      case .top:
        if rows > 0 {
          let indexPath = IndexPath(row: 0, section: 0)
          self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
        break
      case .bottom:
        if rows > 0 {
          let indexPath = IndexPath(row: rows - 1, section: sections - 1)
          self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        break
      }
    }
    
    enum Position {
      case top
      case bottom
    }
}
