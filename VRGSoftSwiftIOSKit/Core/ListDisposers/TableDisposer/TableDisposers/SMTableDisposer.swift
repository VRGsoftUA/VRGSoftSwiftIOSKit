//
//  SMTableDisposer.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 01/31/17.
//  Copyright © 2016 VRG Soft. All rights reserved.
//

import UIKit

public protocol SMTableViewDataSource: class
{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

public protocol SMTableDisposerDelegate: UITableViewDelegate, SMTableViewDataSource
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didSetupCell aCell: UITableViewCell, at aIndexPath: IndexPath)
}

public protocol SMTableDisposerMulticastDelegate: class
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell)
    func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}


open class SMTableDisposer: SMListDisposer, UITableViewDelegate, UITableViewDataSource
{
    open var tableView: UITableView?
    {
        didSet
        {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    open var sections: [SMSectionReadonly] = []
    {
        didSet
        {
            for section: SMSectionReadonly in sections
            {
                section.tableDisposer = self
            }
        }
    }

    open func addSection(_ aSection: SMSectionReadonly)
    {
        sections.append(aSection)
    }
    
    open func removeSection(_ aSection: SMSectionReadonly)
    {
        aSection.tableDisposer = nil
        
        if let index = sections.index(where: {$0 === aSection})
        {
            sections.remove(at: index)
        }
    }
    
    open weak var delegate: SMTableDisposerDelegate?
    
    open let multicastDelegate: SMMulticastDelegate<SMTableDisposerMulticastDelegate> = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate
    
    open func didCreate(cell aCell: UITableViewCell)
    {
        delegate?.tableDisposer(self, didCreateCell: aCell)
        
        multicastDelegate.invokeDelegates { delegate in
            delegate.tableDisposer(self, didCreateCell: aCell)
        }
    }

    open func didSetup(cell aCell: UITableViewCell, at aIndexPath: IndexPath)
    {
        delegate?.tableDisposer(self, didSetupCell: aCell, at: aIndexPath)
    }

    open func index(by aSection: SMSectionReadonly) -> Int
    {
        if let index = sections.index(where: {$0 === aSection})
        {
            return index
        }
        
        return NSNotFound
    }

    override open var listView: UIScrollView?
    {
        return tableView
    }

    override open func reloadData()
    {
        if let tableView = tableView as? SMKeyboardAvoidingTableView
        {
            tableView.removeAllObjectsForKeyboard()
        }
        
        for section: SMSectionReadonly in sections
        {
            section.updateCellDataVisibility()
        }
        
        tableView?.reloadData()
    }
    
    open func cellData(by aIndexPath: IndexPath) -> SMCellData
    {
        return sections[aIndexPath.section].cellData(at: aIndexPath.row)
    }
    
    open func indexPath(by aCellData: SMCellData) -> IndexPath?
    {
        for (index, section) in sections.enumerated()
        {
            if let cellDataIndex = section.cellDataSource.index(where: {$0 === aCellData})
            {
                return IndexPath(row: cellDataIndex, section: index)
            }
        }
        
        return nil
    }

    
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[section].visibleCellDataCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = sections[indexPath.section].cell(forIndex: indexPath.row)
        
        didSetup(cell: result, at: indexPath)
        
        return result
    }

    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section].headerTitle
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return sections[section].footerTitle
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView(tableView, canEditRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView(tableView, canMoveRowAt: indexPath) ?? false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return delegate?.sectionIndexTitles(for: tableView)
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return delegate?.tableView(tableView, sectionForSectionIndexTitle: title, at: index) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        delegate?.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        delegate?.tableView(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    
    // MARK: UITableViewDelegate
    
    // Display customization
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
        
        multicastDelegate.invokeDelegates { delegate in
            delegate.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        delegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    {
        delegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
    {
        delegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
    {
        delegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }

    
    // Variable height support
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = sections[indexPath.section].visibleCellDataSource[indexPath.row]
        
        if cellData.isCellHeightAutomaticDimension
        {
            return UITableViewAutomaticDimension
        } else
        {
            cellData.cellWidth = tableView.frame.size.width
            return cellData.cellHeightFor(width: tableView.frame.size.width)
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cellData: SMCellData = sections[indexPath.section].visibleCellDataSource[indexPath.row]
        cellData.cellWidth = tableView.frame.size.width
        return cellData.cellHeightFor(width: tableView.frame.size.width)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if let headerView = sections[section].headerView
        {
            result = headerView.frame.size.height
        } else if sections[section].headerTitle?.count ?? 0 > 0
        {
            result = 20
        }
        
        return result
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        var result: CGFloat = 0
        
        if let footerView = sections[section].footerView
        {
            result = footerView.frame.size.height
        } else  if sections[section].footerTitle?.count ?? 0 > 0
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
        return sections[section].headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return sections[section].footerView
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    
    // Selection
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return delegate?.tableView?(tableView, willSelectRowAt: indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return delegate?.tableView?(tableView, willDeselectRowAt: indexPath) ?? indexPath
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cellData: SMCellData = self.cellData(by: indexPath)
        cellData.didSelectClosure?(cellData)
        cellData.performSelectedHandlers()

        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
        if cellData.isAutoDeselect
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cellData: SMCellData = sections[indexPath.section].visibleCellData(at: indexPath.row)
        
        cellData.performDeselectedHandlers()
        
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }

    
    // Editing
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        return delegate?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? UITableViewCellEditingStyle.delete
    }
    
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        return delegate?.tableView?(tableView, editActionsForRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    {
        delegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    {
        delegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }

    
    // Moving/reordering
    
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    {
        return delegate?.tableView?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath) ?? IndexPath()
    }


    // Indentation
    
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    {
        return delegate?.tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
    }

    
    // Copy/Paste.
    
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    {
        return delegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    {
        delegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }

    
    // Focus
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        return delegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    {
        return delegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? false
    }

    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    {
        delegate?.tableView?(tableView, didUpdateFocusIn: context, with: coordinator)
    }

    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    {
        return delegate?.indexPathForPreferredFocusedView?(in: tableView)
    }
    
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
    {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}


public extension SMTableViewDataSource
{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return false }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { return false }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? { return nil }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return 0 }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
}


public extension SMTableDisposerDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell) { }
    
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didSetupCell aCell: UITableViewCell, at aIndexPath: IndexPath) { }
}


public extension SMTableDisposerMulticastDelegate
{
    func tableDisposer(_ aTableDisposer: SMTableDisposer, didCreateCell aCell: UITableViewCell) { }
    
    func tableView(_ aTableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
}
