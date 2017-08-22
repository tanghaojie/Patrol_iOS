//
//  JSON_Event.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSON_Event {
    
    var id: Int = 0
    var uid: Int = 0
    var realname: String?
    var eventname: String?
    var typecode: String?
    var levelcode: String?
    var location: CLLocationCoordinate2D?
    var address: String?
    var statecode: String?
    var actualtime: Date?
    var createtime: Date?
    var remark: String?
    var picturecount: Int = 0
    var typecode_alias: String?
    var levelcode_alias: String?
    var statecode_alias: String?
    
    init (_ json: JSON){

        let id = json["id"]
        if id != JSON.null {
            self.id = id.int!
        }
        
        let uid = json["uid"]
        if uid != JSON.null {
            self.uid = uid.int!
        }
        
        let realname = json["realname"]
        if realname != JSON.null {
            self.realname = realname.string
        }
        
        let eventname = json["eventname"]
        if eventname != JSON.null {
            self.eventname = eventname.string
        }
        
        let typecode = json["typecode"]
        if typecode != JSON.null {
            self.typecode = typecode.string
        }
        
        let levelcode = json["levelcode"]
        if levelcode != JSON.null {
            self.levelcode = levelcode.string
        }
        
        let location = json["location"]
        if location != JSON.null {
            let x = location["x"]
            let y = location["y"]
            if x != JSON.null && y != JSON.null {
                let loca = CLLocationCoordinate2D(latitude: y.double!, longitude: x.double!)
                self.location = loca
            }
        }
        
        let address = json["address"]
        if address != JSON.null {
            self.address = address.string
        }
        
        let statecode = json["statecode"]
        if statecode != JSON.null {
            self.statecode = statecode.string
        }
        
        let actualtime = json["actualtime"]
        if actualtime != JSON.null {
            self.actualtime = getDateFormatter(dateFormatter: kDateTimeFormate).date(from: actualtime.string!)
        }
        
        let createtime = json["createtime"]
        if createtime != JSON.null {
            self.createtime = getDateFormatter(dateFormatter: kDateTimeFormate).date(from: createtime.string!)
        }
        
        let remark = json["remark"]
        if remark != JSON.null {
            self.remark = remark.string
        }
        
        let picturecount = json["picturecount"]
        if picturecount != JSON.null {
            self.picturecount = picturecount.int!
        }
        
        let typecode_alias = json["typecode_alias"]
        if typecode_alias != JSON.null {
            self.typecode_alias = typecode_alias.string
        }
        
        let levelcode_alias = json["levelcode_alias"]
        if levelcode_alias != JSON.null {
            self.levelcode_alias = levelcode_alias.string
        }
        
        let statecode_alias = json["statecode_alias"]
        if statecode_alias != JSON.null {
            self.statecode_alias = statecode_alias.string
        }
    }
    
}
