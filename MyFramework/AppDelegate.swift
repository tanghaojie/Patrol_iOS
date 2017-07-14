//
//  AppDelegate.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        if((launchOptions?.index(forKey: .location)) != nil){
//            if(MLocationManager.instance.responds(to: #selector(MLocationManager.instance.requestAlwaysAuthorization))){
//                MLocationManager.instance.requestAlwaysAuthorization()
//            }
//        }
        SystemInit()
        return true
    }
    
    


}

