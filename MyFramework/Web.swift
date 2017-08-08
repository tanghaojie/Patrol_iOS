//
//  Web.swift
//  MyFramework
//
//  Created by JT on 2017/6/23.
//  Copyright © 2017年 JT. All rights reserved.
//


//URL

//var url_Main = "http://119.6.30.131:10063/patrolapi"
var url_Main = ""

var url_Login: String {
    get{
        return getUrl("/api/user/login")
    }
}

var url_Regist: String {
    get{
        return getUrl("/api/user/regist")
    }
}

var url_RegistUsernameUniqueCheck: String {
    get{
         return getUrl("/api/user/validateusername")
    }
}

var url_Config: String {
    get{
        return getUrl("/api/config/GetGroupConfig")
    }
}

var url_CurrentTask: String {
    get{
        return getUrl("/api/task/CurrentTask")
    }
}

var url_CreateTask: String {
    get{
        return getUrl("/api/task/CreateTask")
    }
}

var url_EndTask: String {
    get{
        return getUrl("/api/task/EndTask")
    }
}

var url_UploadPoints: String {
    get{
        return  getUrl("/api/track/UploadPoints")
    }
}

var url_CreateEvent: String {
    get{
        return getUrl("/api/event/CreateEvent")
    }
}

var url_QueryEventList: String {
    get{
        return getUrl("/api/event/QueryRelationEventList")
    }
}

var url_QueryProcessList: String {
    get{
        return getUrl("/api/process/QueryProcessList")
    }
}

var url_QueryImage: String {
    get{
        return getUrl("/api/image/QueryImage")
    }
}

var url_Picture: String {
    get{
        return getUrl("/api/Picture")
    }
}

var url_CreateProcessExecute: String {
    get{
        return getUrl("/api/process/CreateProcessExecute")
    }
}

var url_UploadImage: String {
    get{
        return getUrl("/api/image/UploadImage")
    }
}

public func getUploadImage(prid: String,typenum: String,actualtime: String) -> String {
    return "\(url_UploadImage)?prid=\(prid)&typenum=\(typenum)&actualtime=\(actualtime)"
}

let kShortTimeoutInterval = 5
let kLongTimeoutInterval = 20

public enum HttpMethod: String{
    case Get = "GET"
    case Post = "POST"
}

func getUrl(_ sub: String) -> String {
    return "\(url_Main)\(sub)"
}



