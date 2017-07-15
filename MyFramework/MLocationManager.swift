//
//  MLocationManager.swift
//  MyFramework
//
//  Created by JT on 2017/7/13.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class MLocationManager: CLLocationManager , CLLocationManagerDelegate {
    
    public static let instance = MLocationManager()
    
    private override init(){
        super.init()
        self.delegate = self
        
        //self.requestWhenInUseAuthorization()
        self.requestAlwaysAuthorization()
        
        self.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        self.pausesLocationUpdatesAutomatically = false
        if #available(iOS 9.0, *) {
            self.allowsBackgroundLocationUpdates = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
        print("did update location")
//        if let lastLocation = locations.last {
//            let coordinate = lastLocation.coordinate
//            let dateTime = Date().addingTimeInterval(kTimeInteval)
//            print("coor:\(coordinate.longitude)   \(coordinate.latitude)   \(dateTime)")
//            locationWithDate.append(TCoordinate(location: coordinate, time: dateTime))
//        }else{
//            print("did not update location")
//        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //self.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //print("heading:\(newHeading.trueHeading.binade)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
    }
    
    
    
}
