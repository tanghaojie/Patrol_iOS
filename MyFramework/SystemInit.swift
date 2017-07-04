//
//  SystemInit.swift
//  MyFramework
//
//  Created by JT on 2017/6/26.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

public func SystemInit(){
    
    if(!SQLiteManager.instance.openDB(dbName: kDBName)){
        printLog(message: "can not create sqlite database [" + kDBName + "]")
        exit(0)
    }
    if(!SQLiteManager.instance.executeSQL(sql: kSql_CreateUserTable)){
        printLog(message: "can not create sqlite table [" + kTableName_User + "]")
        exit(0)
    }
    
    loginUser = nil
    HTTPCookieStorage.shared.cookieAcceptPolicy = .always
}

