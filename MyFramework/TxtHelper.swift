//
//  TxtHelper.swift
//  MyFramework
//
//  Created by JT on 2017/8/7.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

func readText(fileUrl: URL) -> String? {
    
    if(!FileManager.default.fileExists(atPath: fileUrl.path)){
        return nil
    }
    let fileHandle = FileHandle(forReadingAtPath: fileUrl.path)
    if let handle = fileHandle {
        let data = handle.readDataToEndOfFile()
        handle.closeFile()
        
        return String.init(data: data, encoding: String.Encoding.utf8)
    }
    return nil
}

//  /var/mobile/Containers/Data/Application/607AB87A-E34D-483A-AD31-CD5F23766265/Documents/setting.txt
//  /var/mobile/Containers/Data/Application/657092E5-0AAF-4EB7-9F5A-D2511B4A3AB4/Documents/setting.txt
//  /var/mobile/Containers/Data/Application/657092E5-0AAF-4EB7-9F5A-D2511B4A3AB4/Documents/setting.txt
func writeText(fileUrl : URL, str : String) {
    
    if !FileManager.default.fileExists(atPath: fileUrl.path) {
        FileManager.default.createFile(atPath: fileUrl.path, contents: nil, attributes: nil)
    }
    
    let fileHandle = try? FileHandle(forWritingTo: fileUrl)
    if let handle = fileHandle {
        handle.write(str.data(using: String.Encoding.utf8)!)
        handle.closeFile()
    }
}

