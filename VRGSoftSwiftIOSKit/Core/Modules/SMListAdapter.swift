//
//  SMListAdapter.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 4/19/18.
//  Copyright © 2018 VRG Soft. All rights reserved.
//

import UIKit

public typealias SMListAdapterClosureType = () -> Bool

public protocol SMListAdapterDelegate: AnyObject {
    
    func prepareSectionsFor(listAdapter aListAdapter: SMListAdapter)
    func defaultSectionForlistAdapter(_ aListAdapter: SMListAdapter) -> SMListSection?
    func listAdapter(_ aListAdapter: SMListAdapter, sectionForModels aModels: [Any], indexOfSection aIndex: Int) -> SMListSection?
    func listAdapter(_ aListAdapter: SMListAdapter, needAddModels aModels: [Any], toSection aSection: SMListSection, withLastModel aLastModel: Any) -> Bool
    func moreCellDataForListAdapter(_ aListAdapter: SMListAdapter) -> SMPagingMoreCellDataProtocol?
}


public protocol SMListAdapterMoreDelegate: AnyObject {
    
    func needLoadMore(listAdapter aListAdapter: SMListAdapter)
    func forceLoadMore(listAdapter aListAdapter: SMListAdapter)
}


open class SMListAdapter {
    
    open var listDisposer: SMListDisposer
    var listDisposerModeled: SMListDisposerSetupModelProtocol? { return listDisposer as? SMListDisposerSetupModelProtocol }
    
    open var moreCell: SMPagingMoreCellProtocol?

    open weak var moreDelegate: SMListAdapterMoreDelegate?
    open weak var delegate: SMListAdapterDelegate?
    
    public init(listDisposer aListDisposer: SMListDisposer) {
        
        listDisposer = aListDisposer
    }

    open func reloadData() {
        
    }
    
    open func prepareSections() {
        
        if delegate == nil {
            
            if let section: SMListSection = defaultSection() {
                
                listDisposer.sections.removeAll()
                listDisposer.addSection(section)
            }
        } else {
            
            delegate?.prepareSectionsFor(listAdapter: self)
        }
    }

    open func defaultSection() -> SMListSection? {
        
        return nil
    }
    
    open func cleanMoreCellData() {
        
        for section: SMListSection in listDisposer.sections {
            
            var moreCellDatas: [SMListCellData] = []
            
            for cd: SMListCellData in section.cellDataSource where cd is SMPagingMoreCellDataProtocol {
                
                moreCellDatas.append(cd)
            }
            
            for cd: SMListCellData in moreCellDatas {
                
                section.removeCellData(cd)
            }
        }
    }
    
    open func updateSectionWith(models aModels: [Any], lastModel aLastModel: Any?, sectionIndex aSectionIndex: Int, needLoadMore aNeedLoadMore: SMListAdapterClosureType?) {
        
        var section: SMListSection?
        
        if let aLastModel: Any = aLastModel,
            let lastSection: SMListSection = listDisposer.sections.last,
            delegate?.listAdapter(self, needAddModels: aModels, toSection: lastSection, withLastModel: aLastModel) == true {
            
            section = lastSection
        } else {
            
            section = sectionForModels(aModels, indexOfSection: aSectionIndex)
        }
        
        guard let sectionForModels: SMListSection = section else {
            
            assert(false, "SMListAdapter: section for listDisposer is nil!")
            return
        }
        
        setupModels(aModels, forSection: sectionForModels)
        
        if aNeedLoadMore?() == true {
            
            addMoreCellData(section: sectionForModels)
        }
    }
    
    open func sectionForModels(_ aModels: [Any], indexOfSection aSectionIndex: Int) -> SMListSection? {
        
        var section: SMListSection?
        
        if let value: SMListSection = delegate?.listAdapter(self, sectionForModels: aModels, indexOfSection: aSectionIndex) {
            
            section = value
            listDisposer.addSection(value)
        } else if let value: SMListSection = listDisposer.sections.last {
            section = value
        } else if let value: SMListSection = delegate?.defaultSectionForlistAdapter(self) {
            section = value
            listDisposer.addSection(value)
        }
        
        return section
    }
    
    open func addMoreCellData(section: SMListSection) {
        
        if let moreCellData: SMPagingMoreCellDataProtocol = delegate?.moreCellDataForListAdapter(self) {
            
            if let moreCellDataType: SMListCellData.Type = type(of: moreCellData) as? SMListCellData.Type {
                
                listDisposerModeled?.register(cellDataClass: moreCellDataType, forModelClass: nil)
                moreCellData.needLoadMore = SMBlockAction(block: { [weak self] _ in
                    
                    if let strongSelf: SMListAdapter = self {
                        
                        strongSelf.moreDelegate?.needLoadMore(listAdapter: strongSelf)
                    }
                })
                
                moreCellData.didTapButtonLoadMore = SMBlockAction(block: { [weak self] _ in
                    
                    if let strongSelf: SMListAdapter = self {
                        
                        strongSelf.moreDelegate?.forceLoadMore(listAdapter: strongSelf)
                    }
                })
                
                if let moreCellData: SMListCellData = moreCellData as? SMListCellData {
                    
                    section.addCellData(moreCellData)
                }
            }
        }
    }

    open func setupModels(_ aModels: [Any], forSection aSection: SMListSection) {
        
        listDisposerModeled?.setupModels(aModels, forSection: aSection)
    }

    
    // MARK: - Load More
    
    open func didBeginDataLoading() {
        
        moreCell?.didBeginDataLoading()
    }
    
    open func didEndDataLoading() {
        
        moreCell?.didEndDataLoading()
    }
}
