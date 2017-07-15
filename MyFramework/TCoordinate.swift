//
//  TCoordinate.swift
//  MyFramework
//
//  Created by JT on 2017/7/13.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

class TCoordinate{
    var location : CLLocationCoordinate2D
    var time : Date
    init(location : CLLocationCoordinate2D, time : Date){
        self.location = location
        self.time = time
    }
}
