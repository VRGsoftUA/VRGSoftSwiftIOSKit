//
//  SMCollectionDisposer.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 4/11/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public protocol SMCollectionViewDataSource: class {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    func indexTitles(for collectionView: UICollectionView) -> [String]?
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath
}


public protocol SMCollectionDisposerMulticastDelegate: class {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}

public protocol SMCollectionDisposerDelegate: UICollectionViewDelegateFlowLayout, SMCollectionViewDataSource { // swiftlint:disable:this class_delegate_protocol
    func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didSetupCell aCell: UICollectionViewCell, at aIndexPath: IndexPath)
}


open class SMCollectionDisposer: SMListDisposer, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    open override var listView: UIScrollView? {
        didSet {
            if let collectionView: UICollectionView = listView as? UICollectionView {
                
                collectionView.delegate = self
                collectionView.dataSource = self
            }
        }
    }
    
    open var collectionView: UICollectionView? { return listView as? UICollectionView }
    
    open var collectionClass: UICollectionView.Type = UICollectionView.self

    open weak var delegate: SMCollectionDisposerDelegate?
    
    public let multicastDelegate: SMMulticastDelegate<SMCollectionDisposerMulticastDelegate> = SMMulticastDelegate(options: NSPointerFunctions.Options.weakMemory) // swiftlint:disable:this weak_delegate
    
    open func didSetup(cell aCell: UICollectionViewCell, at aIndexPath: IndexPath) {
        delegate?.collectionDisposer(self, didSetupCell: aCell, at: aIndexPath)
    }
    
    open func index(by aSection: SMSectionReadonly) -> Int {
        
        if let index: Int = sections.firstIndex(where: {$0 === aSection}) {
            return index
        }
        
        return NSNotFound
    }
    
    override open func reloadData() {
        
        for section: SMListSection in sections {
            section.updateCellDataVisibility()
        }
        
        collectionView?.reloadData()
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].visibleCellDataCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let result: UICollectionViewCell = (sections[indexPath.section] as! SMCollectonSection).cell(forIndexPath: indexPath) // swiftlint:disable:this force_cast
        
        didSetup(cell: result, at: indexPath)
        
        return result
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var result: UICollectionReusableView = UICollectionReusableView(frame: CGRect.zero)
        
        if let section: SMCollectonSection = sections[indexPath.section] as? SMCollectonSection {
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                result = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: section.headerViewIdentifier, for: indexPath as IndexPath)
                section.headerSetupBlock?(result)
            case UICollectionView.elementKindSectionFooter:
                result = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: section.footerViewIdentifier, for: indexPath as IndexPath)
                section.footerSetupBlock?(result)
            default:
                break
            }
        }
        
        return result
    }
    
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView(collectionView, canMoveItemAt: indexPath) ?? false
    }
    
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        delegate?.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
    
    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        
        return delegate?.indexTitles(for: collectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        
        return delegate?.collectionView(collectionView, indexPathForIndexTitle: title, at: index) ?? IndexPath()
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldHighlightItemAt: indexPath) ?? true
    }

    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didHighlightItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didUnhighlightItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellData: SMListCellData = self.cellData(by: indexPath)
        cellData.baSelect?.performBlockFrom(sender: cellData)
        delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
        
        multicastDelegate.invokeDelegates { delegate in
            delegate.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
    
    @available(iOS, introduced: 6.0, deprecated: 13.0, renamed: "collectionView(_:contextMenuConfigurationForItemAt:point:)")
    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldShowMenuForItemAt: indexPath) ?? false
    }
    
    @available(iOS, introduced: 6.0, deprecated: 13.0, renamed: "collectionView(_:contextMenuConfigurationForItemAt:point:)")
    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        
        return delegate?.collectionView?(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender) ?? false
    }
    
    @available(iOS, introduced: 6.0, deprecated: 13.0, renamed: "collectionView(_:contextMenuConfigurationForItemAt:point:)")
    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        delegate?.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
    }
    
    open func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        
        return delegate?.collectionView?(collectionView,
                                         transitionLayoutForOldLayout: fromLayout,
                                         newLayout: toLayout) ?? fromLayout as? UICollectionViewTransitionLayout ?? UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    open func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, canFocusItemAt: indexPath) ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldUpdateFocusIn: context) ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        delegate?.collectionView?(collectionView, didUpdateFocusIn: context, with: coordinator)
    }
    
    open func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        
        return delegate?.indexPathForPreferredFocusedView?(in: collectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        return delegate?.collectionView?(collectionView, targetIndexPathForMoveFromItemAt: originalIndexPath, toProposedIndexPath: proposedIndexPath) ?? proposedIndexPath
    }
    
    open func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        return delegate?.collectionView?(collectionView, targetContentOffsetForProposedContentOffset: proposedContentOffset) ?? CGPoint()
    }
    
    @available(iOS 11.0, *)
    open func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldSpringLoadItemAt: indexPath, with: context) ?? false
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return delegate?.collectionView?(collectionView, contextMenuConfigurationForItemAt: indexPath, point: point)
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        
        return delegate?.collectionView?(collectionView, shouldBeginMultipleSelectionInteractionAt: indexPath) ?? false
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        
        delegate?.collectionView?(collectionView, didBeginMultipleSelectionInteractionAt: indexPath)
    }
    
    @available(iOS 13.0, *)
    public func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
        
        delegate?.collectionViewDidEndMultipleSelectionInteraction?(collectionView)
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return delegate?.collectionView?(collectionView, previewForHighlightingContextMenuWithConfiguration: configuration)
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        return delegate?.collectionView?(collectionView, previewForDismissingContextMenuWithConfiguration: configuration)
    }
    
    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        delegate?.collectionView?(collectionView, willPerformPreviewActionForMenuWith: configuration, animator: animator)
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var result: CGSize?

        if let cd: SMCollectionCellData = sections[indexPath.section].cellData(at: indexPath.row) as? SMCollectionCellData {
            
            result = cd.cellSizeFor(size: collectionView.frame.size)
            
            if result == nil {
                result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
            }
            
            if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                result = collectionViewLayout.itemSize
            }
        }

        return result ?? CGSize.zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt aSection: Int) -> UIEdgeInsets {
        
        var result: UIEdgeInsets?
        
        result = (sections[aSection] as? SMCollectonSection)?.insetForSection
        
        if result == nil {
            result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: aSection)
        }
        
        if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            result = collectionViewLayout.sectionInset
        }
        
        return result ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt aSection: Int) -> CGFloat {
        
        var result: CGFloat?
        
        result = (sections[aSection] as? SMCollectonSection)?.minimumLineSpacing
        
        if result == nil {
            result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: aSection)
        }
        
        if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            result = collectionViewLayout.minimumLineSpacing
        }
        
        return result ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt aSection: Int) -> CGFloat {
        
        var result: CGFloat?
        
        result = (sections[aSection] as? SMCollectonSection)?.minimumInteritemSpacing
        
        if result == nil {
            result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: aSection)
        }
        
        if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            result = collectionViewLayout.minimumInteritemSpacing
        }
        
        return result ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection aSection: Int) -> CGSize {
        
        var result: CGSize?
        
        result = (sections[aSection] as? SMCollectonSection)?.headerReferenceSize
        
        if result == nil {
            result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: aSection)
        }
        
        if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            result = collectionViewLayout.headerReferenceSize
        }
        
        return result ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection aSection: Int) -> CGSize {
        
        var result: CGSize?
        
        result = (sections[aSection] as? SMCollectonSection)?.footerReferenceSize
        
        if result == nil {
            result = delegate?.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: aSection)
        }
        
        if result == nil, let collectionViewLayout: UICollectionViewFlowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            result = collectionViewLayout.footerReferenceSize
        }
        
        return result ?? .zero
    }
    
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
    {
        delegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return delegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return delegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

public extension SMCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool { return false }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
    func indexTitles(for collectionView: UICollectionView) -> [String]? { return nil }
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        assert(false)
        return IndexPath()
    }
}


public extension SMCollectionDisposerMulticastDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
}

public extension SMCollectionDisposerDelegate {
    func collectionDisposer(_ aCollectionDisposer: SMCollectionDisposer, didSetupCell aCell: UICollectionViewCell, at aIndexPath: IndexPath) { }
}
