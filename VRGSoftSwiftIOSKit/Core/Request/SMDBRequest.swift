//
//  SMDataBaseRequest.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 7/5/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import CoreData

open class SMDBRequest: SMRequest
{
    open var storage: SMDBStorage
    open var cancelled: Bool = false
    open var executing: Bool = false
    
    open let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    
    public init(storage aStorage: SMDBStorage, fetchRequest aFetchRequest: NSFetchRequest<NSFetchRequestResult>)
    {
        storage = aStorage
        fetchRequest = aFetchRequest
    }
    
    
    // MARK: Request execute
    
    override open func canExecute() -> Bool
    {
        return true
    }
    
    override open func start()
    {
        self.cancelled = false
        self.executing = true
        
        storage.defaultContext(block: { [weak self] aContext in
            guard let strongSelf = self else { return }
            if strongSelf.isCancelled()
            {
                strongSelf.executing = false
                let response = SMResponse()
                response.isCancelled = true
                response.isSuccess = true
                
                if strongSelf.executeAllResponseBlocksSync
                {
                    strongSelf.executeSynchronouslyAllResponseBlocks(response: response)
                } else
                {
                    strongSelf.executeAllResponseBlocks(response: response)
                }
            } else
            {
                let response = strongSelf.executeRequest(request: strongSelf.fetchRequest, inContext: aContext)
                response.isSuccess = true
                strongSelf.executing = false
                
                if strongSelf.executeAllResponseBlocksSync
                {
                    strongSelf.executeSynchronouslyAllResponseBlocks(response: response)
                } else
                {
                    strongSelf.executeAllResponseBlocks(response: response)
                }
            }
        })
    }
    
    
    // MARK: 

    open func executeRequest(request aRequest: NSFetchRequest<NSFetchRequestResult>, inContext aContext: NSManagedObjectContext) -> SMResponse
    {
        var aError: Error? = nil
        var results = [AnyObject]()
        
        do {
            results = try aContext.fetch(aRequest)
        } catch {
            aError = error
        }
        let response = SMResponse()
        if results.count > 0
        {
            response.boArray.append(contentsOf: results)
        }
        response.error = aError
        response.isCancelled = self.isCancelled()
        response.isSuccess = response.error != nil && !response.isCancelled
        
        return response
    }
    
    override open func cancel()
    {
        cancelled = true
    }
    
    override open func isExecuting() -> Bool
    {
        return executing
    }
    
    override open func isCancelled() -> Bool
    {
        return cancelled
    }
}