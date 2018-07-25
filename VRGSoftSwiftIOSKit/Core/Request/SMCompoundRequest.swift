//
//  SMCompoundRequest.swift
//  time-capsule-ios
//
//  Created by developer on 7/17/18.
//  Copyright © 2018 OLEKSANDR SEMENIUK. All rights reserved.
//

import UIKit

open class SMCompoundRequest: SMRequest
{
    open var canceled = false
    open var finished = false
    open var executing = false
    open var currentExecutingIndex: Int = 0
    
    open var executingRequestingParallel = false
    open var putResponseToOneResult = false
    open var continueRequestssIfAtLeastOneFail = false
    
    open var requests: [SMRequest] = [SMRequest]()
    
    public init(withRequests aRequests: [SMRequest])
    {
        if aRequests.count == 0
        {
            assert(false)
        }
        
        requests = aRequests
        
        super.init()
    }
    
    open var canExecute: Bool
    {
        let result: Bool = requests.filter { request in !request.canExecute()}.count > 0
        
        return result
    }
    
    open override func start()
    {
        retainSelf()
        
        canceled = false
        executing = true
        finished = false
        
        if executingRequestingParallel
        {
            startParallel()
        } else
        {
            startSequence()
        }
    }
    
    private func startParallel()
    {
        let requestGroup = DispatchGroup()
        
        var responses = [SMResponse](repeating: SMResponse(), count: requests.count)
        
        for index in 0...requests.count - 1
        {
            let request = requests[index]
            
            requestGroup.enter()
            
            request.startWithResponseBlockInMainQueue { response in
                responses[index] = response
                requestGroup.leave()
            }
        }
        
        requestGroup.notify(queue: DispatchQueue.main) { [weak self] in
            self?.finishedAllRequestsWithResponces(aResponses: responses)
        }
    }
    
    private func startSequence()
    {
        startRequest(withIndex: 0)
        
        var responses = [SMResponse](repeating: SMResponse(), count: requests.count)
        
        for index in 0...responses.count-1
        {
            requests[index].addResponseBlock({ [weak self] (aResponse) in
                
                guard let strongSelf = self else { return }
                
                responses[index] = aResponse
                
                if aResponse.isSuccess
                {
                        if index < strongSelf.requests.count - 1
                        {
                            strongSelf.startRequest(withIndex: index + 1)
                        } else
                        {
                            strongSelf.finishedAllRequestsWithResponces(aResponses: responses)
                        }
                } else
                {
                    if strongSelf.continueRequestssIfAtLeastOneFail
                    {
                        if index < strongSelf.requests.count - 1
                        {
                            strongSelf.startRequest(withIndex: index + 1)
                        } else
                        {
                            strongSelf.finishedAllRequestsWithResponces(aResponses: responses)
                        }
                    } else
                    {
                        strongSelf.finishedAllRequestsWithResponces(aResponses: responses)
                    }
                }
            }, responseQueue: DispatchQueue.global(qos: .background))
        }
        
    }
    
    open func finishedAllRequestsWithResponces(aResponses: [SMResponse])
    {
        let result: SMResponse = SMResponse()
        result.isSuccess = true
        
        if putResponseToOneResult
        {
            result.boArray = aResponses
        } else
        {
            for response in aResponses
            {
                if !response.isSuccess && result.isSuccess
                {
                    result.isSuccess =  response.isSuccess
                    result.error = response.error
                    result.titleMessage = response.titleMessage
                    result.textMessage = response.textMessage
                }
                
                result.boArray.append(response.boArray as AnyObject)
                response.dataDictionary.forEach { (key, value) in
                    result.dataDictionary[key] = value
                    
                }
            }
        }
        
        executing = false
        finished = true
        
        executeAllResponseBlocks(response: result)
        
        retainSelf()
    }
    
    open override func cancel()
    {
        canceled = true
        executing = false
        finished = true
        
        requests[currentExecutingIndex].cancel()
    }
    
    open func startRequest(withIndex aIndex: Int)
    {
        currentExecutingIndex = aIndex
        requests[currentExecutingIndex].start()
    }
    
}
