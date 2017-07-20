//
//  EventModel.swift
//  MyFramework
//
//  Created by JT on 2017/7/17.
//  Copyright © 2017年 JT. All rights reserved.
//

class EventModel{
    
    var uid: Int?
    var eventId: Int?
    var eventName: String?
    var eventTypeCode: String?
    var eventLevelCode: String?
    var location: CLLocationCoordinate2D?
    var address: String?
    var date:Date?
    var remark: String?
    var images: [UIImage]?
    

    init(uid: Int?,eventId: Int?, eventName: String?,eventTypeCode: String?,eventLevelCode: String?, location: CLLocationCoordinate2D?, address: String?, date: Date?, remark: String?, images: [UIImage]?){
        self.uid = uid
        self.eventId = eventId
        self.eventName = eventName
        self.eventTypeCode = eventTypeCode
        self.eventLevelCode = eventLevelCode
        self.location = location
        self.address = address
        self.date = date
        self.remark = remark
        self.images = images
    }
}
