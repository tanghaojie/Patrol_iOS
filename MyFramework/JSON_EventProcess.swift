//
//  JSON_EventProcess.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSON_EventProcess {
    var total: Int = 0
    var datas: [JSON_Process] = [JSON_Process]()
    var status: Int = -1
    var msg: String?
    
    init(_ json: JSON) {
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
                        datas.append(JSON_Process(item))
                    }
                }
            }
        }
    }
    
}
