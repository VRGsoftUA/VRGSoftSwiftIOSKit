//
//  SMSectionReadonly.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

open class SMSectionReadonly: SMListSection {
    
    open weak var tableDisposer: SMTableDisposer? {
        
        return disposer as? SMTableDisposer
    }
    
    open var headerTitle: String?
    open var footerTitle: String?
    open var headerView: UIView?
    open var footerView: UIView?
    
    
    // MARK: Cells
    
    open func cell(forIndex aIndex: Int) -> UITableViewCell {
        
        let cellData: SMCellData = visibleCellData(at: aIndex) as! SMCellData// swiftlint:disable:this force_cast

        let reusableCell: UITableViewCell? = tableDisposer?.tableView?.dequeueReusableCell(withIdentifier: cellData.cellIdentifier)
        
        let isNewCell: Bool = reusableCell == nil

        let cell: UITableViewCell = reusableCell ?? cellData.createCell()
        
        (cell as? SMCellProtocol)?.setupCellData(cellData)
        
        if isNewCell {
            
            tableDisposer?.didCreate(cell: cell)
        }
        
        return cell
    }
    
    open func reload(with anAnimation: UITableView.RowAnimation) {
        
        updateCellDataVisibility()
        
        if let section: Int = tableDisposer?.index(by: self) {
            
            tableDisposer?.tableView?.reloadSections(IndexSet(integer: section), with: anAnimation)
        }
    }
    
    open func reloadRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        var indexPaths: [IndexPath] = []
        var indexPath: IndexPath
        
        let sectionIndex: Int = tableDisposer?.index(by: self) ?? 0
        
        for index: Int in aIndexes {
            
            indexPath = IndexPath(row: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        
        tableDisposer?.tableView?.reloadRows(at: indexPaths, with: aRowAnimation)
    }
    
    open func deleteRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        var toDelete: [SMListCellData] = []
        
        for index: Int in aIndexes {
            
            let cellData: SMListCellData = self.cellData(at: index)
            toDelete.append(cellData)
        }
        
        for cd: SMListCellData in toDelete {
            
            removeCellData(cd)
        }
        
        updateCellDataVisibility()
        
        var indexPaths: [IndexPath] = []
        var indexPath: IndexPath
        
        let sectionIndex: Int = tableDisposer?.index(by: self) ?? 0
        
        for index: Int in aIndexes {
            
            indexPath = IndexPath(row: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        
        tableDisposer?.tableView?.deleteRows(at: indexPaths, with: aRowAnimation)
    }
    
    
    // MARK: Show/Hide cells
    
    open func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool) {
        
        hideCell(by: aIndex, needUpdateTable: aNeedUpdateTable, withRowAnimation: UITableView.RowAnimation.middle)
    }

    open func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool) {
        
        showCell(by: aIndex, needUpdateTable: aNeedUpdateTable, withRowAnimation: UITableView.RowAnimation.middle)
    }

    open func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        let cellData: SMListCellData  = self.cellData(at: aIndex)

        if !cellData.isVisible {
            
            return
        }
        
        let index: Int = self.index(byVisible: cellData)
        
        if  let i: Int = cellDataSource.index(where: {$0 === cellData}) {
            
            cellDataSource.remove(at: i)
        }

        cellData.isVisible = false
        
        if aNeedUpdateTable, let section: Int = tableDisposer?.index(by: self) {
            
            let indexPath: IndexPath = IndexPath(row: index, section: section)
            tableDisposer?.tableView?.deleteRows(at: Array(repeating: indexPath, count: 1), with: aRowAnimation)
        }
    }
    
    open func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        let cellData: SMListCellData  = self.cellData(at: aIndex)
        
        if cellData.isVisible {
            
            return
        }
        
        let index: Int = self.index(byVisible: cellData)
        
        cellData.isVisible = true
        updateCellDataVisibility()
        
        if aNeedUpdateTable, let section: Int = tableDisposer?.index(by: self) {
            
            let indexPath: IndexPath = IndexPath(row: index, section: section)
            tableDisposer?.tableView?.insertRows(at: Array(repeating: indexPath, count: 1), with: aRowAnimation)
        }
    }
}
