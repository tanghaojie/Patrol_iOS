//
//  JSON_Uid.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSON_Uid {
    var id: Int = 0
    var realname: String?
    var phone: String?
    
    init(_ json: JSON){
        let id = json["id"]
        if id != JSON.null {
            self.id = id.int!
        }
        
        let realname = json["realname"]
        if realname != JSON.null {
            self.realname = realname.string
        }
        
        let phone = json["phone"]
        if phone != JSON.null {
            self.phone = phone.string
        }
    }
    
}
