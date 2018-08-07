//
//  SMListSection.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

open class SMListSection<CellDataType: SMListCellData>
{
    open var cellDataSource: [CellDataType] = []
    open var visibleCellDataSource: [CellDataType] = []
    
    
    public init()
    {
        
    }
    
    // MARK: CellDatas
    
    open func addCellData(_ aCellData: CellDataType)
    {
        cellDataSource.append(aCellData)
    }
    
    open func addCellDataFromArray(_ aCellDatas: [CellDataType])
    {
        cellDataSource.append(contentsOf: aCellDatas)
    }
    
    open func insertCellData(_ aCellData: CellDataType, index aIndex: Int)
    {
        cellDataSource.insert(aCellData, at: aIndex)
    }
    
    open func removeCellDataAtIndex(_ aIndex: Int)
    {
        cellDataSource.remove(at: aIndex)
    }
    
    open func removeCellData(_ aCellData: CellDataType)
    {
        if  let index: Int = cellDataSource.index(where: {$0 === aCellData})
        {
            cellDataSource.remove(at: index)
        }
    }
    
    open func removeAllCellData()
    {
        cellDataSource.removeAll()
    }
    
    open func cellData(at anIndex: Int) -> CellDataType
    {
        return cellDataSource[anIndex]
    }
    
    open func visibleCellData(at anIndex: Int) -> CellDataType
    {
        return visibleCellDataSource[anIndex]
    }
    
    open func index(by aCellData: CellDataType) -> Int
    {
        if  let index: Int = cellDataSource.index(where: {$0 === aCellData})
        {
            return index
        }
        
        return NSNotFound
    }
    
    open func index(byVisible aCellData: CellDataType) -> Int
    {
        if  let index: Int = visibleCellDataSource.index(where: {$0 === aCellData})
        {
            return index
        }
        
        return NSNotFound
    }
    
    open func cellData(byTag aTag: Int) -> CellDataType?
    {
        var result: CellDataType? = nil
        for cd: CellDataType in cellDataSource where cd.tag == aTag
        {
            result = cd
            break
        }
        
        return result
    }
    
    open var cellDataCount: Int
    {
        return cellDataSource.count
    }
    
    open var visibleCellDataCount: Int
    {
        return visibleCellDataSource.count
    }
    
    open func updateCellDataVisibility()
    {
        visibleCellDataSource.removeAll()
        
        for cd: CellDataType in cellDataSource where cd.isVisible
        {
            visibleCellDataSource.append(cd)
        }
    }
}
