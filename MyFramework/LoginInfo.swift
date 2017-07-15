//
//  SystemUser.swift
//  MyFramework
//
//  Created by JT on 2017/6/29.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

var loginInfo : LoginInfo? = nil

class LoginInfo{
    var userId : Int?
    var realname : String?
    var username : String?
    var rolename : String?
    var protraiurl : String?
    var config : Config?
    var taskId : Int? = nil
}
