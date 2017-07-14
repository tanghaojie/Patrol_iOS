//
//  Common.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

let kStatusBarHeight = 20
let kScreenWidth = UIScreen.main.bounds.width
let kScrennHeight = UIScreen.main.bounds.height
let kMainBottomTabBarHeight : CGFloat = 40

let kTimeZone = TimeZone.current
let kTimeInteval = TimeInterval(Double(kTimeZone.secondsFromGMT()))

let kDateTimeFormate = "yyyy-MM-dd HH:mm:ss"

func getDateFormatter(dateFormatter : String) -> DateFormatter{
    let kFormatter = DateFormatter()
    kFormatter.timeZone = TimeZone(identifier: "UTC")
    kFormatter.locale = Locale(identifier: "zh_CN")
    kFormatter.dateFormat = dateFormatter
    return kFormatter
}


extension UIColor{
    convenience init(red : CGFloat, green : CGFloat, blue : CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

let kDBName = "appDB.sqlite"

let kTableName_User = "T_User"
let kSql_CreateUserTable = "CREATE TABLE IF NOT EXISTS '" + kTableName_User + "' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'user' TEXT UNIQUE,'pass' TEXT);"
let kSql_SelectUserTableLast = "select * from '" + kTableName_User + "' order by id desc limit 1"

func getInsertOrReplaceSql(username : String,password : String) -> String{
    return "insert or replace into '" + kTableName_User + "' (user,pass)values ('" + username + "','" + password + "')"
}




