//
//  Cache.swift
//  MyFramework
//
//  Created by JT on 2017/8/24.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation
import SwiftyJSON

let cacheDirName = "PatrolCache"

public func getCacheDirPath(dirName: String = cacheDirName) -> String {
    let full = "\(cachePath ?? "")/\(dirName)"
    var isDir = ObjCBool(false)
    let isExist = FileManager.default.fileExists(atPath: full, isDirectory: &isDir)
    if !isExist || !isDir.boolValue {
        try? FileManager.default.createDirectory(atPath: full, withIntermediateDirectories: true, attributes: nil)
    }
    return full
}

public func getCacheDirPath(cachePath: String, typenum: String, prid: String, isCover: Bool) -> String {
    var fullDir = cachePath.appending("/\(typenum)")
    fullDir.append("/\(prid)")
    var isDir = ObjCBool(false)
    if isCover {
        try? FileManager.default.removeItem(atPath: fullDir)
    }
    let isExist = FileManager.default.fileExists(atPath: fullDir, isDirectory: &isDir)
    if !isExist || !isDir.boolValue {
        try? FileManager.default.createDirectory(atPath: fullDir, withIntermediateDirectories: true, attributes: nil)
    }
    
    return fullDir
}

public func cacheImages(images: [UIImage], typenum: String, prid: String, isCover: Bool) {
    let cachePath = getCacheDirPath()
    let fullDir = getCacheDirPath(cachePath: cachePath, typenum: typenum, prid: prid, isCover: isCover)
    
    let count = images.count
    for index in 0..<count {
        let image = images[index]
        let fullPath = fullDir.appending("/\(index)")
        if let imgData = UIImageJPEGRepresentation(image, 1) {
            try? imgData.write(to: URL.init(fileURLWithPath: fullPath), options: Data.WritingOptions.atomic)
        }
    }
}



