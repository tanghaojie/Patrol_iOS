//
//  Web.swift
//  MyFramework
//
//  Created by JT on 2017/6/23.
//  Copyright © 2017年 JT. All rights reserved.
//


//URL
let url_Main = "http://192.168.0.122/test"
let url_Login = "\(url_Main)/api/user/login"
let url_Regist = "\(url_Main)/api/user/regist"
let url_RegistUsernameUniqueCheck = "\(url_Main)/api/user/validateusername"

let kShortTimeoutInterval = 5

public enum HttpMethod: String{
    case Get = "GET"
    case Post = "POST"
}


