//
//  SMNativeMoreCollectionViewCell.swift
//  whaleslide-ios
//
//  Created by OLEKSANDR SEMENIUK on 5/8/18.
//  Copyright © 2018 WhaleSlide. All rights reserved.
//

import UIKit

open class SMNativeMoreCollectionViewCellData: SMCollectionCellData, SMPagingMoreCellDataProtocol
{
    public var needLoadMore: SMBlockAction<Any>?
    
    public convenience init()
    {
        self.init(model: nil)
    }
    
    override open class var cellClass_: UICollectionViewCell.Type
    {
        return SMNativeMoreCollectionViewCell.self
    }
    
    override open func cellSizeFor(size aSize: CGSize) -> CGSize?
    {
        return CGSize(width: 45.0, height: 45.0)
    }
}

open class SMNativeMoreCollectionViewCell: SMCollectionCell, SMPagingMoreCellProtocol
{
    open let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
    override open func setup()
    {
        super.setup()
        
        activity.hidesWhenStopped = true
        activity.center = CGPoint(x: self.contentView.width/2, y: self.contentView.height/2)
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        self.contentView.addSubview(activity)
    }
    
    override open func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.showActivityIndicator(show: false)
    }
    
    open func showActivityIndicator(show aIsShow: Bool)
    {
        if aIsShow
        {
            activity.startAnimating()
        } else
        {
            activity.stopAnimating()
        }
    }
    
    
    // MARK: SMPagingMoreCellProtocol
    
    public func didBeginDataLoading()
    {
        self.showActivityIndicator(show: true)
    }
    
    public func didEndDataLoading()
    {
        self.showActivityIndicator(show: false)
    }
}
