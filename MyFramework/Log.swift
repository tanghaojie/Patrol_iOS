//
//  Log.swift
//  MyFramework
//
//  Created by JT on 2017/6/23.
//  Copyright © 2017年 JT. All rights reserved.
//
import Foundation

let logFileName = "log.txt"
let log_SystemStart = "System start"
let log_Login_InsertOrReplaceUsernamePasswordError = "Login insert or replace username/password error"
let log_ServerNoResponse = "Server has no response"
let log_Timeout = "Time out"

public func printLog<T>(message: T, file: String = #file, function: String = #function, line: Int = #line){

    let dateFormat = DateFormatter()
    dateFormat.dateFormat = kDateTimeFormate
    var now = Date()
    now.addTimeInterval(kTimeInteval)
    let dateStr = dateFormat.string(from: now)
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    let filePath = path?.appending(logFileName)
    guard let f = filePath else { return }
    let url = URL(fileURLWithPath: f)
    let logStr = "\(dateStr) | \(file) line:\(line) \(function) | \(message)"
    appendText(fileUrl: url, str: logStr)
}

private func appendText(fileUrl : URL, str : String){
    if(!FileManager.default.fileExists(atPath: fileUrl.path)){
        FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
    }
    let fileHandle = try? FileHandle(forWritingTo: fileUrl)
    let wstr = "\n" + str
    fileHandle?.seekToEndOfFile()
    fileHandle?.write(wstr.data(using: String.Encoding.utf8)!)
}
