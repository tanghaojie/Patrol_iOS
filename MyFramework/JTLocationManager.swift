//
//  MLocationManager.swift
//  MyFramework
//
//  Created by JT on 2017/7/13.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTLocationManager: CLLocationManager {
    
    static let instance = JTLocationManager.init()
    
    private override init(){
        super.init()

        self.requestAlwaysAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    
        self.pausesLocationUpdatesAutomatically = false
        if #available(iOS 9.0, *) {
            self.allowsBackgroundLocationUpdates = true
        }
    }
 
}
