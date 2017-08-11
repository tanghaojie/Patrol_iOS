//
//  MAGSLocationDisplayDataSource.swift
//  MyFramework
//
//  Created by JT on 2017/8/11.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTAGSLocationDisplayDataSource: NSObject, AGSLocationDisplayDataSource, CLLocationManagerDelegate {

    static let instance = JTAGSLocationDisplayDataSource()
    
    var delegate: AGSLocationDisplayDataSourceDelegate!
    var isStarted: Bool
    var error: Error!
    
    let locationManager = JTLocationManager.instance
    
    private override init() {
        isStarted = false
        
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func start() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        self.delegate.locationDisplayDataSourceStarted(self)
        
        isStarted = true
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
        self.delegate.locationDisplayDataSourceStopped(self)
        
        isStarted = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let agsLocation = AGSLocation(clLocation: location)
        
        self.delegate.locationDisplayDataSource(self, didUpdateWith: agsLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        self.delegate.locationDisplayDataSource(self, didUpdateWithHeading: newHeading.trueHeading)
    }
    
    
    


    
}
