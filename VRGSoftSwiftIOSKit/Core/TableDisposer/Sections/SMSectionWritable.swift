//
//  SMSectionWritable.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

class SMSectionWritable: SMSectionReadonly
{
    var cells: [UITableViewCell]! = []
    
    func mapToObject() -> Void
    {
        for cellData: SMCellData in cellDataSource
        {
            if cellData is SMCellDataMaped
            {
                (cellData as! SMCellDataMaped).mapToObject()
            }
        }
    }

    func mapFromObject() -> Void
    {
        for cellData: SMCellData in cellDataSource
        {
            if cellData is SMCellDataMaped
            {
                (cellData as! SMCellDataMaped).mapFromObject()
            }
        }
    }
    
    //TODO:
    func createCell(at anIndex: Int) -> UITableViewCell
    {
        let cellData = self.visibleCellData(at: anIndex)
        let cell = cellData.createCell()
        
        if cell is SMCellProtocol
        {
            (cell as! SMCellProtocol).cellData = cellData
        }
    
        if tableDisposer!.tableView is SMKeyboardAvoidingProtocol && cell is SMCell
        {
            if let inputTraits = (cell as! SMCell).inputTraits()
            {
                (tableDisposer!.tableView as! SMKeyboardAvoidingProtocol).addObjectsForKeyboard(inputTraits)
                if tableDisposer!.tableView is SMKeyboardAvoidingTableView
                {
                    (tableDisposer!.tableView as! SMKeyboardAvoidingTableView).sortedResponders(inputTraits, byIndexPath: IndexPath(row: anIndex, section: tableDisposer!.index(by: self)))
                }
            }
        }

        return cell
    }

   func createCells() -> Void
   {
        // remove old cells
        cells.removeAll()
        self.updateCellDataVisibility()
    
        var cell: UITableViewCell
        for index in 0..<visibleCellDataSource.count
        {
            cell = self.createCell(at: index)
            cells.append(cell)
        }
    }
    
    override func cell(forIndex aIndex: Int) -> UITableViewCell
    {
        return cells[aIndex]
    }
    
    //TODO:
    override func reload(with anAnimation: UITableViewRowAnimation)
    {
        if tableDisposer!.tableView is SMKeyboardAvoidingProtocol
        {
            for cell in self.cells
            {
                if cell is SMCell, let inputTrails = (cell as! SMCell).inputTraits()
                {
                    (tableDisposer!.tableView as! SMKeyboardAvoidingProtocol).removeObjectsForKeyboard(inputTrails)
                }
            }
        }
        
        self.mapToObject()
        
        super.reload(with: anAnimation)
    }

    //TODO:
    override func reloadRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableViewRowAnimation)
    {
        var indexPaths : [IndexPath] = []
        var indexPath : IndexPath
        let sectionIndex : Int = tableDisposer!.index(by: self)
        
        var cellData : SMCellData
        var cell : UITableViewCell
        
        for index in aIndexes
        {
            cellData = self.visibleCellData(at: index)
            
            if cellData is SMCellDataMaped
            {
                (cellData as! SMCellDataMaped).mapFromObject()
            }

            cell = self.cell(forIndex: index)
            
            (cell as! SMCellProtocol).setupCellData(cellData)
            
            indexPath = IndexPath(item: index, section: sectionIndex)
            indexPaths.append(indexPath)
        }
        
        tableDisposer!.tableView!.reloadRows(at: indexPaths, with: aRowAnimation)
    }

    //TODO:
    override func showCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableViewRowAnimation)
    {
        let cellData : SMCellData! = self.cellData(at: aIndex)
        
        if cellData.isVisible
        {
            return
        }
        
        cellData.isVisible = true
        self.updateCellDataVisibility()
        
        let index: Int = self.index(byVisible: cellData)
        let cell : UITableViewCell = self.createCell(at: index)
        cells.insert(cell, at: index)
        
        if aNeedUpdateTable
        {
            let indexPath : IndexPath = IndexPath(row: index, section: tableDisposer!.index(by: self))
            tableDisposer!.tableView!.insertRows(at: [indexPath], with: aRowAnimation)
        }
    }
    
    //TODO:
    override func hideCell(by aIndex: Int, needUpdateTable aNeedUpdateTable: Bool, withRowAnimation aRowAnimation: UITableViewRowAnimation)
    {
        let cellData : SMCellData! = self.cellData(at: aIndex)
        
        if !cellData.isVisible
        {
            return
        }
        
        let index : Int = self.index(byVisible: cellData)
        
        let cell : UITableViewCell = self.cell(forIndex: index)
        
        if tableDisposer!.tableView is SMKeyboardAvoidingProtocol && cell is SMCell
        {
            if let inputTraits = (cell as! SMCell).inputTraits()
            {
                (tableDisposer!.tableView as! SMKeyboardAvoidingProtocol).addObjectsForKeyboard(inputTraits)
            }
        }

        visibleCellDataSource.remove(at: index)
        cells.remove(at: index)
        cellData.isVisible = false
        
        if aNeedUpdateTable
        {
            let indexPath : IndexPath = IndexPath(row: index, section: tableDisposer!.index(by: self))
            tableDisposer!.tableView!.deleteRows(at: [indexPath], with: aRowAnimation)
        }
    }
    
    override func deleteRows(at aIndexes: [Int], withRowAnimation aRowAnimation: UITableViewRowAnimation)
    {
        super.deleteRows(at: aIndexes, withRowAnimation: aRowAnimation)
        
        for index : Int in aIndexes
        {
            cells.remove(at: index)
        }
    }
}

