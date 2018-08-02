//
//  SMModuleRemotePushes.swift
//  SwiftKit
//
//  Created by OLEKSANDR SEMENIUK on 1/30/17.
//  Copyright © 2017 VRG Soft. All rights reserved.
//

import UIKit

open class SMModuleRemotePushes
{
    var deviceToken: String?
    
//    open func tryToRegisterForUserNotificationDefault() -> Void
//    {
//        self.tryToRegisterFor(userNotificationTypes: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
//    }
//
//    open func tryToRegisterFor(userNotificationTypes aUserNotificationTypes: UIUserNotificationType) -> Void
//    {
//        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: aUserNotificationTypes, categories: nil)
//        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
//    }

    open func didRegisterForRemoteNotificationsWith(deviceTokenData aDeviceTokenData: Data)
    {
        var token: String = ""
        for i: Int in 0..<aDeviceTokenData.count
        {
            token += String(format: "%02.2hhx", aDeviceTokenData[i] as CVarArg)
        }
        
        deviceToken = token
        
        if deviceToken != nil
        {
            registerForPushNotifications()
        }
    }
    
    open func registerForPushNotifications()
    {
        if deviceToken != nil && canRegisterDeviceToken()
        {
            registerDeviceTokenRequest()?.start()
        }
    }

    open func unregisterForPushNotifications()
    {
        if deviceToken != nil && canUnregisterDeviceToken()
        {
            unregisterDeviceTokenRequest()?.start()
        }
    }

    open func registerDeviceTokenRequest() -> SMRequest?
    {
        return nil
    }

    open func unregisterDeviceTokenRequest() -> SMRequest?
    {
        return nil
    }

    open func canRegisterDeviceToken() -> Bool
    {
        return true
    }
    
    open func canUnregisterDeviceToken() -> Bool
    {
        return true
    }
}
