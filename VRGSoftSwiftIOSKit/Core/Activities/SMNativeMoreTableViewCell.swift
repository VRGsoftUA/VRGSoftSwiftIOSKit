//
//  SMNativeMoreTableViewCell.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 8/3/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMNativeMoreTableViewCellData: SMCellData, SMPagingMoreCellDataProtocol {
    
    public var needLoadMore: SMBlockAction<Any>?
    
    public var didTapButtonLoadMore: SMBlockAction<Any>?
    
    convenience public init() {
        
        self.init(model: nil)
    
        self.cellClass = SMNativeMoreTableViewCell.self
        self.cellSelectionStyle = UITableViewCell.SelectionStyle.none
        self.cellHeight = 45
    }
}

open class SMNativeMoreTableViewCell: SMCell, SMPagingMoreCellProtocol {

    public let activity: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    
    override open func setup() {
        
        super.setup()
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.width)
        
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
