//
//  TaskModel.swift
//  MyFramework
//
//  Created by JT on 2017/7/12.
//  Copyright © 2017年 JT. All rights reserved.
//

class TaskModel{
    var isStarted : Bool = false
    var taskid : Int?
    var userid : Int?
    var taskName : String?
    var taskTypeCode : String?
    var startTime : Date?
    var remark : String?
    
    init(isStarted : Bool, tid : Int?, uid : Int?, tName : String?, tType : String?, startTime : Date?, remark : String?){
        self.isStarted = isStarted
        self.taskid = tid
        self.userid = uid
        self.taskName = tName
        self.taskTypeCode = tType
        self.startTime = startTime
        self.remark = remark
    }
}
