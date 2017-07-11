//
//  Config.swift
//  MyFramework
//
//  Created by JT on 2017/7/11.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

class Config{
    
    var success : Bool = false
    var msg : String = ""
    var taskType : [TaskType] = [TaskType]()
    var eventType : [EventType] = [EventType]()
    var eventLevel : [EventLevel] = [EventLevel]()

    init(id : Int){
        var urlRequest = URLRequest(url: URL(string: url_Config)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = ("id="+String(id)).data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        
        do{
            var response : URLResponse?
            let data = try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.msg = String(statusCode) + msg_HttpError
                    printLog(message: String(statusCode) + msg_HttpError + url_Config)
                }
                if(data.isEmpty){
                    self.msg = msg_ServerNoResponse
                    printLog(message: log_ServerNoResponse + url_Config)
                }
                
                let json = JSON(data : data)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let data = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            self.msg = msg
                        }
                    }
                    if data != JSON.null {
                        for item in data{
                            let obj = item.1
                            let typeCode = obj["typecode"]
                            let list = obj["list"]
                            if(typeCode.string == TaskType.taskTypeCode){
                                for l in list{
                                    let code = l.1["code"].string
                                    let alias = l.1["alias"].string
                                    if(code != nil && alias != nil){
                                        self.taskType.append(TaskType(code: code!, alias: alias!))
                                    }
                                }
                            }else if(typeCode.string == EventType.eventTypeCode){
                                for l in list{
                                    let code = l.1["code"].string
                                    let alias = l.1["alias"].string
                                    if(code != nil && alias != nil){
                                        self.eventType.append(EventType(code: code!, alias: alias!))
                                    }
                                }
                            }else if(typeCode.string == EventLevel.eventLevelCode){
                                for l in list{
                                    let code = l.1["code"].string
                                    let alias = l.1["alias"].string
                                    if(code != nil && alias != nil){
                                        self.eventLevel.append(EventLevel(code: code!, alias: alias!))
                                    }
                                }
                            }
                        }
                        self.success = true
                    }else{
                        // running there must be webapi error
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self.msg = msg_ServerNoResponse
                printLog(message: log_ServerNoResponse + url_Login)
            }
            success = true
        }catch let error{
            success = false
            self.msg = msg_ConnectTimeout
            printLog(message:  String(describing: error) + log_Timeout + url_Config)
        }
    }
}

class TaskType{
    static let taskTypeCode = "0001010001000001"

    init(code : String, alias : String){
        self.code = code
        self.alias = alias
    }
    var code : String
    var alias : String
}

class EventType{
    static let eventTypeCode = "0001010001000002"

    init(code : String, alias : String){
        self.code = code
        self.alias = alias
    }
    var code : String
    var alias : String
}

class EventLevel{
    static let eventLevelCode = "0001010001000003"
    
    init(code : String, alias : String){
        self.code = code
        self.alias = alias
    }
    var code : String
    var alias : String
}
