//
//  SMSectionWritable.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

open class SMSectionWritable: SMSectionReadonly {
    
    open var cells: [UITableViewCell] = []
    
    open func mapToObject() {
        
        for cellData: SMListCellData in cellDataSource where cellData is SMCellDataMapedProtocol {
            
            (cellData as? SMCellDataMapedProtocol)?.mapToObject()
        }
    }

    open func mapFromObject() {
        
        for cellData: SMListCellData in cellDataSource where cellData is SMCellDataMapedProtocol {
            
            (cellData as? SMCellDataMapedProtocol)?.mapFromObject()
        }
        
        createCells()
    }
    
    //TODO:
    open func createCell(at anIndex: Int) -> UITableViewCell {
        
        let cellData: SMCellData = visibleCellData(at: anIndex) as! SMCellData// swiftlint:disable:this force_cast
        
        let cell: UITableViewCell = cellData.createCell()
        
        (cell as? SMCellProtocol)?.setupCellData(cellData)
    
        if let keyboardAvoiding: SMKeyboardAvoidingProtocol = tableDisposer?.tableView as? SMKeyboardAvoidingProtocol,
            let cell: SMCell = cell as? SMCell,
            let tableDisposer: SMTableDisposer = tableDisposer {
            
                if let inputTraits: [UIResponder] = cell.inputTraits() {
                    
                    keyboardAvoiding.addObjectsForKeyboard(inputTraits)
                    
                    if let tableView: SMKeyboardAvoidingTableView = tableDisposer.tableView as? SMKeyboardAvoidingTableView {
                        
                        tableView.sortedResponders(inputTraits, byIndexPath: IndexPath(row: anIndex, section: tableDisposer.index(by: self)))
                    }
                }
        }

        return cell
    }

   open func createCells() {
    
        // remove old cells
        cells.removeAll()
        updateCellDataVisibility()
    
        var cell: UITableViewCell
    
        for index: Int in 0..<visibleCellDataSource.count {
        
            cell = createCell(at: index)
            cells.append(cell)
        }
    }
    
    override open func cell(forIndex aIndex: Int) -> UITableViewCell {
        
        return cells[aIndex]
    }
    
    //TODO:
    override open func reload(with anAnimation: UITableView.RowAnimation) {
        
        if let keyboardAvoiding: SMKeyboardAvoidingProtocol = tableDisposer?.tableView as? SMKeyboardAvoidingProtocol {
            
            for cell: UITableViewCell in cells where cell is SMCell {
                
                if let inputTrails: [UIResponder] = (cell as? SMCell)?.inputTraits() {
                    
                    keyboardAvoiding.removeObjectsForKeyboard(inputTrails)
                }
            }
        }
        
        mapToObject()
        
        super.reload(with: anAnimation)
    }

    //TODO:
    override open func reloadRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        var indexPaths: [IndexPath] = []
        var indexPath: IndexPath
        let sectionIndex: Int = tableDisposer?.index(by: self) ?? 0
        
        var cellData: SMListCellData
        var cell: UITableViewCell
        
        for index: Int in aIndexes {
            
            cellData = visibleCellData(at: index)
            
            (cellData as? SMCellDataMapedProtocol)?.mapFromObject()
            
            cell = self.cell(forIndex: index)
            
            (cell as? SMCellProtocol)?.setupCellData(cellData)
            
            indexPath = IndexPath(item: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        
        tableDisposer?.tableView?.reloadRows(at: indexPaths, with: aRowAnimation)
    }

    //TODO:
    override open func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        let cellData: SMListCellData = self.cellData(at: aIndex)
        
        if cellData.isVisible {
            
            return
        }
        
        cellData.isVisible = true
        updateCellDataVisibility()
        
        let index: Int = self.index(byVisible: cellData)
        let cell: UITableViewCell = createCell(at: index)
        cells.insert(cell, at: index)
        
        if aNeedUpdateTable, let tableDisposer: SMTableDisposer = tableDisposer {
            
            let indexPath: IndexPath = IndexPath(row: index, section: tableDisposer.index(by: self))
            tableDisposer.tableView?.insertRows(at: [indexPath], with: aRowAnimation)
        }
    }
    
    //TODO:
    override open func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        let cellData: SMListCellData = self.cellData(at: aIndex)
        
        if !cellData.isVisible {
            
            return
        }
        
        let index: Int = self.index(byVisible: cellData)
        
        let cell: UITableViewCell = self.cell(forIndex: index)
        
        if let keyboardAvoiding: SMKeyboardAvoidingProtocol = tableDisposer?.tableView as? SMKeyboardAvoidingProtocol, let cell: SMCell = cell as? SMCell {
            
            if let inputTraits: [UIResponder] = cell.inputTraits() {
                
                keyboardAvoiding.addObjectsForKeyboard(inputTraits)
            }
        }

        visibleCellDataSource.remove(at: index)
        cells.remove(at: index)
        cellData.isVisible = false
        
        if aNeedUpdateTable, let tableDisposer: SMTableDisposer = tableDisposer {
            
            let indexPath: IndexPath = IndexPath(row: index, section: tableDisposer.index(by: self))
            tableDisposer.tableView?.deleteRows(at: [indexPath], with: aRowAnimation)
        }
    }
    
    override open func deleteRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableView.RowAnimation) {
        
        super.deleteRows(at: aIndexes, withRowAnimation: aRowAnimation)
        
        for index: Int in aIndexes {
            
            cells.remove(at: index)
        }
    }
}
