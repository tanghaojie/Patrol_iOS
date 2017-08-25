//
//  Paths.swift
//  MyFramework
//
//  Created by JT on 2017/8/11.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
