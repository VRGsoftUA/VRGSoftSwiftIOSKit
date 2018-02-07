//
//  SMTableDisposer.swift
//  Contractors
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit
import MulticastDelegateSwift

@objc public protocol SMTableViewDataSource : NSObjectProtocol
{
    @objc optional func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    @objc optional func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    @objc optional func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    @objc optional func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

@objc protocol SMTableDisposerDelegate: UITableViewDelegate, SMTableViewDataSource
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didSetupCell aCell: UITableViewCell, at aIndexPath: IndexPath)
}

@objc protocol SMTableDisposerMulticastDelegate: NSObjectProtocol
{
    @objc optional func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)

    @objc optional func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}


open class SMTableDisposer: NSObject, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView?
    {
        didSet
        {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    var sections: [SMSectionReadonly]! = []

    func addSection(_ aSection: SMSectionReadonly) -> Void
    {
        aSection.tableDisposer = self
        sections.append(aSection)
    }
    
    func removeSection(_ aSection: SMSectionReadonly) -> Void
    {
        aSection.tableDisposer = nil
        sections.remove(at: sections.index(of: aSection)!)
    }
    
    var tableClass: AnyClass = UITableView.self
    var tableStyle: UITableViewStyle! = UITableViewStyle.plain
    
    weak var delegate: SMTableDisposerDelegate?
    let multicastDelegate: MulticastDelegate<SMTableDisposerMulticastDelegate> = MulticastDelegate(strongReferences: false)
    
    func didCreate(cell aCell: UITableViewCell)
    {
        if self.delegate != nil && delegate!.tableDisposer(_:didCreateCell:) != nil
        {
            delegate!.tableDisposer!(self, didCreateCell: aCell)
        }
        
        self.multicastDelegate.invokeDelegates { (delegate) in
            delegate.tableDisposer!(self, didCreateCell: aCell)
        }
    }

    func didSetup(cell aCell: UITableViewCell, at aIndexPath: IndexPath)
    {
        if self.delegate != nil && delegate!.tableDisposer(_:didSetupCell:at:) != nil
        {
            delegate!.tableDisposer!(self, didSetupCell: aCell, at: aIndexPath)
        }
    }

    func index(by aSection: SMSectionReadonly) -> Int
    {
        return sections.index(of: aSection)!
    }

    func reloadData() -> Void
    {
        //    if([tableView isKindOfClass:[SMKeyboardAvoidingTableView class]])
        //    {
        //    [((SMKeyboardAvoidingTableView*)tableView) removeAllObjectsForKeyboard];
        //    }

        for section in sections
        {
            section.updateCellDataVisibility()
        }
        
        tableView?.reloadData()
    }
    
    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.sections[section].visibleCellDataCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = self.sections[indexPath.section].cell(forIndex: indexPath.row)
        
        self.didSetup(cell: result, at: indexPath)
        
        return result
    }

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return self.sections[section].headerTitle
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return self.sections[section].footerTitle
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:canEditRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, canEditRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:canMoveRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, canMoveRowAt: indexPath)
        }
        
        return result
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        var result: [String]?
        
        if self.delegate != nil && self.delegate!.sectionIndexTitles != nil
        {
            result = self.delegate!.sectionIndexTitles!(for: tableView)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        var result: Int = 0
        
        if self.delegate != nil && self.delegate!.tableView(_:sectionForSectionIndexTitle:at:) != nil
        {
            result = self.delegate!.tableView!(tableView, sectionForSectionIndexTitle: title, at: index)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:commit:forRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, commit: editingStyle, forRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:moveRowAt:to:) != nil
        {
            self.delegate!.tableView!(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    
    // MARK: UITableViewDelegate
    
    // Display customization
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:willDisplay:forRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }
        
        self.multicastDelegate.invokeDelegates { (delegate) in
            delegate.tableView!(tableView, willDisplay: cell, forRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.tableView(_:willDisplayHeaderView:forSection:) != nil
        {
            self.delegate!.tableView!(tableView, willDisplayHeaderView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.tableView(_:willDisplayFooterView:forSection:) != nil
        {
            self.delegate!.tableView!(tableView, willDisplayFooterView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didEndDisplaying:forRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didEndDisplayingHeaderView:forSection:) != nil
        {
            self.delegate!.tableView!(tableView, didEndDisplayingHeaderView: view, forSection: section)
        }
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didEndDisplayingFooterView:forSection:) != nil
        {
            self.delegate!.tableView!(tableView, didEndDisplayingFooterView: view, forSection: section)
        }
    }

    
    // Variable height support
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellDataSource[indexPath.row]
        
        if cellData.cellHeightAutomaticDimension
        {
            return UITableViewAutomaticDimension
        } else
        {
            cellData.cellWidth = tableView.frame.size.width
            return cellData.cellHeightFor(width: tableView.frame.size.width)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellDataSource[indexPath.row]
        cellData.cellWidth = tableView.frame.size.width
        return cellData.cellHeightFor(width: tableView.frame.size.width)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if let headerView = self.sections[section].headerView
        {
            result = headerView.frame.size.height
        } else  if(self.sections[section].headerTitle != nil && (self.sections[section].headerTitle?.count)! > 0)
        {
            result = 20
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if let headerView = self.sections[section].headerView
        {
            result = headerView.frame.size.height
        } else  if(self.sections[section].footerTitle != nil && (self.sections[section].footerTitle?.count)! > 0)
        {
            result = 20
        }
        
        return result
    }
    
//        @available(iOS 7.0, *)
//        optional public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat

//        @available(iOS 7.0, *)
//        optional public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat

//        @available(iOS 7.0, *)
//        optional public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return self.sections[section].headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return self.sections[section].footerView
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:accessoryButtonTappedForRowWith:) != nil
        {
            self.delegate!.tableView!(tableView, accessoryButtonTappedForRowWith: indexPath)
        }
    }
    
    
    // Selection
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = true
        
        if self.delegate != nil && self.delegate!.tableView(_:shouldHighlightRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, shouldHighlightRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didHighlightRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didHighlightRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didUnhighlightRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didUnhighlightRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        var result: IndexPath? = indexPath
        
        if self.delegate != nil && self.delegate!.tableView(_:willSelectRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, willSelectRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    {
        var result: IndexPath? = indexPath
        
        if self.delegate != nil && self.delegate!.tableView(_:willDeselectRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, willDeselectRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {        
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellData(at: indexPath.row)
        
        cellData.performSelectedHandlers()

        if self.delegate != nil && self.delegate!.tableView(_:didSelectRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
        }
        
        if cellData.isAutoDeselect
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cellData: SMCellData = self.sections[indexPath.section].visibleCellData(at: indexPath.row)
        
        cellData.performDeselectedHandlers()
        
        if self.delegate != nil && self.delegate!.tableView(_:didDeselectRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didDeselectRowAt: indexPath)
        }
    }

    
    // Editing
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        var result: UITableViewCellEditingStyle = UITableViewCellEditingStyle.delete
        
        if self.delegate != nil && self.delegate!.tableView(_:editingStyleForRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, editingStyleForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        var result: String? = nil
        
        if self.delegate != nil && self.delegate!.tableView(_:titleForDeleteConfirmationButtonForRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        var result: [UITableViewRowAction]? = nil
        
        if self.delegate != nil && self.delegate!.tableView(_:editActionsForRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, editActionsForRowAt: indexPath)
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:shouldIndentWhileEditingRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, shouldIndentWhileEditingRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    {
        if self.delegate != nil && self.delegate!.tableView(_:willBeginEditingRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, willBeginEditingRowAt: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didEndEditingRowAt:) != nil
        {
            self.delegate!.tableView!(tableView, didEndEditingRowAt: indexPath)
        }
    }

    
    // Moving/reordering
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    {
        var result: IndexPath = IndexPath()
        
        if self.delegate != nil && self.delegate!.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:) != nil
        {
            result = self.delegate!.tableView!(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath)
        }
        
        return result
    }


    // Indentation
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        var result: Int = 0
        
        if self.delegate != nil && self.delegate!.tableView(_:indentationLevelForRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, indentationLevelForRowAt: indexPath)
        }
        
        return result
    }

    
    // Copy/Paste.
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:shouldShowMenuForRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, shouldShowMenuForRowAt: indexPath)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:canPerformAction:forRowAt:withSender:) != nil
        {
            result = self.delegate!.tableView!(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender)
        }
        
        return result
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    {
        if self.delegate != nil && self.delegate!.tableView(_:performAction:forRowAt:withSender:) != nil
        {
            self.delegate!.tableView!(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
        }
    }

    
    // Focus
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:canFocusRowAt:) != nil
        {
            result = self.delegate!.tableView!(tableView, canFocusRowAt: indexPath)
        }
        
        return result
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    {
        var result: Bool = false
        
        if self.delegate != nil && self.delegate!.tableView(_:shouldUpdateFocusIn:) != nil
        {
            result = self.delegate!.tableView!(tableView, shouldUpdateFocusIn: context)
        }
        
        return result
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    {
        if self.delegate != nil && self.delegate!.tableView(_:didUpdateFocusIn:with:) != nil
        {
            self.delegate!.tableView!(tableView, didUpdateFocusIn: context, with: coordinator)
        }
    }

    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    {
        var result: IndexPath? = nil
        
        if self.delegate != nil && self.delegate!.indexPathForPreferredFocusedView(in:) != nil
        {
            result = self.delegate!.indexPathForPreferredFocusedView!(in: tableView)
        }
        
        return result
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidScroll(_:) != nil
        {
            self.delegate!.scrollViewDidScroll!(scrollView)
        }
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
    {
        if self.delegate != nil && self.delegate!.scrollViewDidZoom(_:) != nil
        {
            self.delegate!.scrollViewDidZoom!(scrollView)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewWillBeginDragging(_:) != nil
        {
            self.delegate!.scrollViewWillBeginDragging!(scrollView)
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        if self.delegate != nil && self.delegate!.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:) != nil
        {
            self.delegate!.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidEndDragging(_:willDecelerate:) != nil
        {
            self.delegate!.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        }
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewWillBeginDecelerating(_:) != nil
        {
            self.delegate!.scrollViewWillBeginDecelerating!(scrollView)
        }
    }

    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidEndDecelerating(_:) != nil
        {
            self.delegate!.scrollViewDidEndDecelerating!(scrollView)
        }
    }

    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidEndScrollingAnimation(_:) != nil
        {
            self.delegate!.scrollViewDidEndScrollingAnimation!(scrollView)
        }
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        var result: UIView? = nil
        
        if self.delegate != nil && self.delegate!.viewForZooming(in:) != nil
        {
            result = self.delegate!.viewForZooming!(in: scrollView)
        }
        
        return result
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        if self.delegate != nil && self.delegate!.scrollViewWillBeginZooming(_:with:) != nil
        {
            self.delegate!.scrollViewWillBeginZooming!(scrollView, with: view)
        }
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidEndZooming(_:with:atScale:) != nil
        {
            self.delegate!.scrollViewDidEndZooming!(scrollView, with: view, atScale: scale)
        }
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    {
        var result: Bool = true
        
        if self.delegate != nil && self.delegate!.scrollViewShouldScrollToTop(_:) != nil
        {
            result = self.delegate!.scrollViewShouldScrollToTop!(scrollView)
        }
        
        return result
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    {
        if self.delegate != nil && self.delegate!.scrollViewDidScrollToTop(_:) != nil
        {
            self.delegate!.scrollViewDidScrollToTop!(scrollView)
        }
    }
}
