//
//  SMTableAdapter.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/19/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit


open class SMTableAdapter: SMListAdapter, SMTableDisposerMulticastDelegate {
    
    public var tableDisposer: SMTableDisposerModeled? { return listDisposer as? SMTableDisposerModeled }

    public override init(listDisposer aListDisposer: SMListDisposer) {
        
        super.init(listDisposer: aListDisposer)
        
        tableDisposer?.multicastDelegate.addDelegate(self)
    }
    
    override open func reloadData() {
        
        listDisposer.reloadData()
    }
    
    
    // MARK: - SMTableDisposerMulticastDelegate
    
    public func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell) {
        
    }
    
    public func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let cell: SMPagingMoreCellProtocol = cell as? SMPagingMoreCellProtocol {
            
            moreCell = cell
            moreDelegate?.needLoadMore(listAdapter: self)
        }
    }
}
