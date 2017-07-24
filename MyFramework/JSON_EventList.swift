//
//  JSON_EventList.swift
//  MyFramework
//
//  Created by JT on 2017/7/21.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSON_EventList {
    var total: Int = 0
    var datas: [JSON_Event] = [JSON_Event]()
    var status: Int = -1
    var msg: String?
    
    init(json: JSON) {
        let nTotal = json["total"].int
        let data = json["data"]
        let nStatus = json["status"].int
        let nMsg = json["msg"].string
        if let total = nTotal {
            self.total = total
        }
        if let status = nStatus {
            self.status = status
        }
        if let msg = nMsg {
            self.msg = msg
        }
        if data != JSON.null {
            let count = data.count
            if count > 0 {
                for index in 0...count - 1 {
                    let item = data[index]
                    if item != JSON.null {
                        datas.append(getData(item: item))
                    }
                }
            }
        }
    }
    
    private func getData(item: JSON) -> JSON_Event {
        let data = JSON_Event()
        
        let id = item["id"]
        if id != JSON.null {
            data.id = id.int!
        }
        
        let uid = item["uid"]
        if uid != JSON.null {
            data.uid = uid.int!
        }
        
        let realname = item["realname"]
        if realname != JSON.null {
            data.realname = realname.string
        }
        
        let eventname = item["eventname"]
        if eventname != JSON.null {
            data.eventname = eventname.string
        }
        
        let typecode = item["typecode"]
        if typecode != JSON.null {
            data.typecode = typecode.string
        }
        
        let levelcode = item["levelcode"]
        if levelcode != JSON.null {
            data.levelcode = levelcode.string
        }
        
        let location = item["location"]
        if levelcode != JSON.null {
            let x = location["x"]
            let y = location["y"]
            if x != JSON.null && y != JSON.null {
                let loca = CLLocationCoordinate2D(latitude: y.double!, longitude: x.double!)
                data.location = loca
            }
        }
        
        let address = item["address"]
        if address != JSON.null {
            data.address = address.string
        }
        
        let statecode = item["statecode"]
        if statecode != JSON.null {
            data.statecode = statecode.string
        }
        
        let actualtime = item["actualtime"]
        if actualtime != JSON.null {
            data.actualtime = getDateFormatter(dateFormatter: kDateTimeFormate).date(from: actualtime.string!)
        }
        
        let createtime = item["createtime"]
        if createtime != JSON.null {
            data.createtime = getDateFormatter(dateFormatter: kDateTimeFormate).date(from: createtime.string!)
        }
        
        let remark = item["remark"]
        if remark != JSON.null {
            data.remark = remark.string
        }
        
        let picturecount = item["picturecount"]
        if picturecount != JSON.null {
            data.picturecount = picturecount.int!
        }
        
        let typecode_alias = item["typecode_alias"]
        if typecode_alias != JSON.null {
            data.typecode_alias = typecode_alias.string
        }
        
        let levelcode_alias = item["levelcode_alias"]
        if levelcode_alias != JSON.null {
            data.levelcode_alias = levelcode_alias.string
        }
        
        let statecode_alias = item["statecode_alias"]
        if statecode_alias != JSON.null {
            data.statecode_alias = statecode_alias.string
        }
    
        return data
    }
}

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
}

