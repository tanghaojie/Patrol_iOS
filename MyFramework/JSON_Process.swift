//
//  JSON_Process.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSON_Process {
    var id: Int = 0
    var eid: Int = 0
    var operatorid: Int = 0
    var operatorname: String?
    var uids: [JSON_Uid] = [JSON_Uid]()
    var processname: String?
    var statecode: String?
    var location: CLLocationCoordinate2D?
    var actualtime: Date?
    var createtime: Date?
    var remark: String?
    var picturecount: Int = 0
    var statecode_alias: String?
    
    init(_ json: JSON){
        let id = json["id"]
        if id != JSON.null {
            self.id = id.int!
        }
        
        let eid = json["eid"]
        if eid != JSON.null {
            self.eid = eid.int!
        }
        
        let operatorid = json["operatorid"]
        if operatorid != JSON.null {
            self.operatorid = operatorid.int!
        }
        
        let operatorname = json["operatorname"]
        if operatorname != JSON.null {
            self.operatorname = operatorname.string
        }
        
        let uids = json["uids"]
        if uids != JSON.null {
            let count = uids.count
            if count > 0 {
                for index in 0...count - 1 {
                    let item = uids[index]
                    self.uids.append(JSON_Uid(item))
                }
            }
        }
        
        let processname = json["processname"]
        if processname != JSON.null {
            self.processname = processname.string
        }
        
        let statecode = json["statecode"]
        if statecode != JSON.null {
            self.statecode = statecode.string
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
        
        let statecode_alias = json["statecode_alias"]
        if statecode_alias != JSON.null {
            self.statecode_alias = statecode_alias.string
        }
    }
}


