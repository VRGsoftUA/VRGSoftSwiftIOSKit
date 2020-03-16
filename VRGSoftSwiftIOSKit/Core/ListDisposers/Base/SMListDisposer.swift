//
//  SMListDisposer.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/24/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMListDisposer: NSObject {
    
    open var listView: UIScrollView?
    
    open func reloadData() {
        
        assert(false)
    }
    
    open var sections: [SMListSection] = [] {
        didSet {
            for section: SMListSection in sections {
                
                section.disposer = self
            }
        }
    }
    
    open func addSection(_ aSection: SMListSection) {
        
        sections.append(aSection)
    }
    
    open func removeSection(_ aSection: SMListSection) {
        
        aSection.disposer = nil
        
        if let index: Int = sections.firstIndex(where: {$0 === aSection}) {
            
            sections.remove(at: index)
        }
    }
    
    open func index(by aSection: SMListSection) -> Int {
        
        if let index: Int = sections.firstIndex(where: {$0 === aSection}) {
            
            return index
        }
        
        return NSNotFound
    }
    
    open func cellData(by aIndexPath: IndexPath) -> SMListCellData {
        
        return sections[aIndexPath.section].cellData(at: aIndexPath.row)
    }
    
    open func indexPath(by aCellData: SMListCellData) -> IndexPath? {
        
        for (index, section): (Int, SMListSection) in sections.enumerated() {
            
            if let cellDataIndex: Int = section.cellDataSource.firstIndex(where: {$0 === aCellData}) {
                
                return IndexPath(row: cellDataIndex, section: index)
            }
        }
        
        return nil
    }
}
