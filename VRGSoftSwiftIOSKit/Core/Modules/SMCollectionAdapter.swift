//
//  SMCollectionAdapter.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/20/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMCollectionAdapter: SMListAdapter, SMCollectionDisposerMulticastDelegate {
    
    public var collectionDisposer: SMCollectionDisposerModeled? { return listDisposer as? SMCollectionDisposerModeled }
    
    public override init(listDisposer aListDisposer: SMListDisposer) {
        
        super.init(listDisposer: aListDisposer)
        
        collectionDisposer?.multicastDelegate.addDelegate(self)
    }
    
    override open func reloadData() {
        
        listDisposer.reloadData()
    }
    
    
    // MARK: - SMCollectionDisposerMulticastDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell: SMPagingMoreCellProtocol = cell as? SMPagingMoreCellProtocol {
            
            moreCell = cell
            moreDelegate?.needLoadMore(listAdapter: self)
        }
    }
}
