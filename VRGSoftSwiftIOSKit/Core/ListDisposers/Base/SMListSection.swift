//
//  SMListSection.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMListSection {
    
    open var cellDataSource: [SMListCellData] = []
    open var visibleCellDataSource: [SMListCellData] = []
    open weak var disposer: SMListDisposer?
    
    public init() { }
    
    // MARK: CellDatas
    
    open func addCellData(_ aCellData: SMListCellData) {
        
        cellDataSource.append(aCellData)
    }
    
    open func addCellDataFromArray(_ aCellDatas: [SMListCellData]) {
        
        cellDataSource.append(contentsOf: aCellDatas)
    }
    
    open func insertCellData(_ aCellData: SMListCellData, index aIndex: Int) {
        
        cellDataSource.insert(aCellData, at: aIndex)
    }
    
    open func removeCellDataAtIndex(_ aIndex: Int) {
        
        cellDataSource.remove(at: aIndex)
    }
    
    open func removeCellData(_ aCellData: SMListCellData) {
        
        if  let index: Int = cellDataSource.firstIndex(where: {$0 === aCellData}) {
            
            cellDataSource.remove(at: index)
        }
    }
    
    open func removeAllCellData() {
        
        cellDataSource.removeAll()
    }
    
    open func cellData(at anIndex: Int) -> SMListCellData {
        
        return cellDataSource[anIndex]
    }
    
    open func visibleCellData(at anIndex: Int) -> SMListCellData {
        
        return visibleCellDataSource[anIndex]
    }
    
    open func index(by aCellData: SMListCellData) -> Int {
        
        if  let index: Int = cellDataSource.firstIndex(where: {$0 === aCellData}) {
            
            return index
        }
        
        return NSNotFound
    }
    
    open func index(byVisible aCellData: SMListCellData) -> Int {
        
        if  let index: Int = visibleCellDataSource.firstIndex(where: {$0 === aCellData}) {
            
            return index
        }
        
        return NSNotFound
    }
    
    open func cellData(byTag aTag: Int) -> SMListCellData? {
        
        var result: SMListCellData?
        
        for cd: SMListCellData in cellDataSource where cd.tag == aTag {
            
            result = cd
            break
        }
        
        return result
    }
    
    open var cellDataCount: Int {
        
        return cellDataSource.count
    }
    
    open var visibleCellDataCount: Int {
        
        return visibleCellDataSource.count
    }
    
    open func updateCellDataVisibility() {
        
        visibleCellDataSource.removeAll()
        
        for cd: SMListCellData in cellDataSource where cd.isVisible {
            
            visibleCellDataSource.append(cd)
        }
    }
}
