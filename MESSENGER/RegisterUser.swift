//
//  RegisterUser.swift
//  MESSENGER
//
//  Created by Kayamba Mukanzu on 6/13/16.
//  Copyright © 2016 Kayamba Mukanzu. All rights reserved.
//

import Foundation

func registerUserDeviceId() {
    
    if (backendless.messagingService.getRegistration().deviceId != nil) {
        
        let deviceId = backendless.messagingService.getRegistration().deviceId
        
        let properties = ["deviceId" : deviceId]
        
        backendless.userService.currentUser!.updateProperties(properties)
        backendless.userService.update(backendless.userService.currentUser)
    }
    
}

func removeDeviceIdFromUser() {
    
    let properties = ["deviceId" : ""]
    
    backendless.userService.currentUser!.updateProperties(properties)
    backendless.userService.update(backendless.userService.currentUser)
    
    
}
