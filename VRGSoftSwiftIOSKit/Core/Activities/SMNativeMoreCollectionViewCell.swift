//
//  SMNativeMoreCollectionViewCell.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 5/8/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

open class SMNativeMoreCollectionViewCellData: SMCollectionCellData, SMPagingMoreCellDataProtocol {
    
    open var needLoadMore: SMBlockAction<Any>?
    
    open var didTapButtonLoadMore: SMBlockAction<Any>?
    
    public convenience init() {
        
        self.init(model: nil)
        
        self.cellSize = CGSize(width: 45.0, height: 45.0)
    }
    
    override open class var cellClass_: UICollectionViewCell.Type {
        
        return SMNativeMoreCollectionViewCell.self
    }
}

open class SMNativeMoreCollectionViewCell: SMCollectionCell, SMPagingMoreCellProtocol {
    
    public let activity: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        
    override open func setup() {
        
        super.setup()
        
        activity.hidesWhenStopped = true
        activity.center = CGPoint(x: self.contentView.width/2, y: self.contentView.height/2)
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        self.contentView.addSubview(activity)
    }
    
    override open func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.showActivityIndicator(show: false)
    }
    
    open func showActivityIndicator(show aIsShow: Bool) {
        
        if aIsShow {
            
            activity.startAnimating()
        } else {
            
            activity.stopAnimating()
        }
    }
    
    
    // MARK: SMPagingMoreCellProtocol
    
    public func didBeginDataLoading() {
        
        self.showActivityIndicator(show: true)
    }
    
    public func didEndDataLoading() {
        
        self.showActivityIndicator(show: false)
    }
}
