//
//  Some_Process_func.swift
//  Cyber-I Data Management System
//
//  Created by guoao on 15/5/29.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation


func Convert_DB_to_JSON(_ dic : Dictionary<String, [String:AnyObject]>) ->JSON
{
    var dic_temp :Dictionary<String,String> = ["":""]
    dic_temp.removeAll(keepingCapacity: true)
    for (key,value) in dic
    {
        //  println("\(key) + \(dic[key]?.asString())")
        dic_temp[key] = dic[key]as?String
    }
    
    
    let json = JSON(dic_temp)
    //  println(json)
    return json
}
