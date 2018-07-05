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
    
    
    // MARK: CellDatas
    
    func addCellData(_ aCellData: CellDataType)
    {
        cellDataSource.append(aCellData)
    }
    
    func addCellDataFromArray(_ aCellDatas: [CellDataType])
    {
        cellDataSource.append(contentsOf: aCellDatas)
    }
    
    func insertCellData(_ aCellData: CellDataType, index aIndex: Int)
    {
        cellDataSource.insert(aCellData, at: aIndex)
    }
    
    func removeCellDataAtIndex(_ aIndex: Int)
    {
        cellDataSource.remove(at: aIndex)
    }
    
    func removeCellData(_ aCellData: CellDataType)
    {
        if  let index = cellDataSource.index(where: {$0 === aCellData})
        {
            cellDataSource.remove(at: index)
        }
    }
    
    func removeAllCellData()
    {
        cellDataSource.removeAll()
    }
    
    func cellData(at anIndex: Int) -> CellDataType
    {
        return cellDataSource[anIndex]
    }
    
    func visibleCellData(at anIndex: Int) -> CellDataType
    {
        return visibleCellDataSource[anIndex]
    }
    
    func index(by aCellData: CellDataType) -> Int
    {
        if  let index = cellDataSource.index(where: {$0 === aCellData})
        {
            return index
        }
        
        return NSNotFound
    }
    
    func index(byVisible aCellData: CellDataType) -> Int
    {
        if  let index = visibleCellDataSource.index(where: {$0 === aCellData})
        {
            return index
        }
        
        return NSNotFound
    }
    
    func cellData(byTag aTag: Int) -> CellDataType?
    {
        var result: CellDataType? = nil
        for cd in cellDataSource where cd.tag == aTag
        {
                result = cd
                break
        }
        
        return result
    }
    
    var cellDataCount: Int
    {

        return cellDataSource.count
    }
    
    var visibleCellDataCount: Int
    {
        return visibleCellDataSource.count
    }
    
    func updateCellDataVisibility()
    {
        visibleCellDataSource.removeAll()
        
        for cd in cellDataSource where cd.isVisible
        {
            visibleCellDataSource.append(cd)
        }
    }
}
