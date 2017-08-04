//
//  SMNativeMoreTableViewCell.swift
//  semenag01kit_Swift
//
//  Created by OLEKSANDR SEMENIUK on 8/3/17.
//  Copyright © 2017 semenag01. All rights reserved.
//

import UIKit

class SMNativeMoreTableViewCellData: SMCellData, SMPagingMoreCellDataProtocol
{
    override init()
    {
        super.init()
        
        self.cellClass = SMNativeMoreTableViewCell.self
        self.cellSelectionStyle = UITableViewCellSelectionStyle.none
        self.cellHeight = 45
    }
}

class SMNativeMoreTableViewCell: UITableViewCell, SMPagingMoreCellProtocol
{

    let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.width)
        
        activity.hidesWhenStopped = true
        activity.center = CGPoint(x: self.contentView.width/2, y: self.contentView.height/2)
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin]
      
        self.contentView.addSubview(activity)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.showActivityIndicator(show: false)
    }
    
    func showActivityIndicator(show aIsShow: Bool) -> Void
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

    func didBeginDataLoading()
    {
        self.showActivityIndicator(show: true)
    }
    
    func didEndDataLoading()
    {
        self.showActivityIndicator(show: false)
    }
}
