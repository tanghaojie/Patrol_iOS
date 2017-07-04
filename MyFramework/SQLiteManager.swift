//
//  SQLiteManager.swift
//  MyFramework
//
//  Created by JT on 2017/6/26.
//  Copyright © 2017年 JT. All rights reserved.
//
import Foundation

class SQLiteManager: NSObject {
    static let instance = SQLiteManager()
    var db :OpaquePointer? = nil
    class func selfInstance() -> SQLiteManager{
        return self.instance
    }
    
    func openDB(dbName : String) -> Bool{
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let dbPath = (docPath! as NSString).appendingPathComponent(dbName)
        let utfDBPath = dbPath.cString(using: .utf8)
        if(sqlite3_open(utfDBPath, &db) == SQLITE_OK){
            return true
        }else{
            return false
        }
    }
    
    func executeSQL(sql : String) -> Bool{
        let cSql = sql.cString(using: String.Encoding.utf8)
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if(sqlite3_exec(db, cSql, nil, nil, errmsg) == SQLITE_OK){
            return true
        }else{
            return false
        }
    }
    
    func queryUser(sql : String) -> [T_User]{
        var userArr = [T_User]()
        let cSql = sql.cString(using: .utf8)
        var stmt:OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, cSql, -1, &stmt, nil) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let user = T_User()
                let id = sqlite3_column_int(stmt, 0)
                let name = UnsafePointer(sqlite3_column_text(stmt, 1))
                let pass = UnsafePointer(sqlite3_column_text(stmt, 2))
                
                user.id = Int(id)
                user.username = String.init(cString: name!)
                user.password = String.init(cString: pass!)

                userArr += [user]
            }
        }
        return userArr
    }

    

    
}
