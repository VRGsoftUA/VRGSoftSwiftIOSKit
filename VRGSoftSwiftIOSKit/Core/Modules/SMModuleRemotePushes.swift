//
//  SMModuleRemotePushes.swift
//  VRGSoftSwiftIOSKit
//
//  Created by OLEKSANDR SEMENIUK on 1/30/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit
import UserNotifications

open class SMModuleRemotePushes: NSObject {
    
    open var deviceToken: String?
    
    open func tryToRegisterAllNotificationSettings() {
        
        self.tryToRegisterFor(userNotificationOptions: [UNAuthorizationOptions.alert, UNAuthorizationOptions.badge, UNAuthorizationOptions.sound])
    }
    
    open func tryToRegisterForUserNotificationDefault() {
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @available(iOS 10.0, *)
    open func tryToRegisterFor(userNotificationOptions aUserNotificationOptions: UNAuthorizationOptions) {
        
        let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
        center.requestAuthorization(options: aUserNotificationOptions) { (_, error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    self.tryToRegisterForUserNotificationDefault()
                }
            }
        }
    }
    
    public override init() {
        
    }
    
    open func didRegisterForRemoteNotificationsWith(deviceTokenData aDeviceTokenData: Data) {
        
        var token: String = ""
        
        for i: Int in 0..<aDeviceTokenData.count {
            
            token += String(format: "%02.2hhx", aDeviceTokenData[i] as CVarArg)
        }
        
        deviceToken = token
        
        if deviceToken != nil {
            
            registerForPushNotifications()
        }
    }
    
    open func registerForPushNotifications() {
        
        if deviceToken != nil && canRegisterDeviceToken() {
            
            registerDeviceTokenRequest()?.start()
        }
    }
    
    open func unregisterForPushNotifications() {
        
        if deviceToken != nil && canUnregisterDeviceToken() {
            
            unregisterDeviceTokenRequest()?.start()
        }
    }
    
    open func registerDeviceTokenRequest() -> SMRequest? {
        
        return nil
    }
    
    open func unregisterDeviceTokenRequest() -> SMRequest? {
        
        return nil
    }
    
    open func canRegisterDeviceToken() -> Bool {
        
        return true
    }
    
    open func canUnregisterDeviceToken() -> Bool {
        
        return true
    }
}
