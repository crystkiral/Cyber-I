//
//  Data collection processor.swift
//  Cyber-I Data Management System
//
//  Created by guoao on 15/6/22.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation

class Data_Collection_Processor{
    var ReadTime_HeartRate = 60*60
    var ReadTime_Step = 60*60
    var ReadTime_SleepData = 60*60*24
    var ReadTime_ActiveEnergyBurned = 60*60
    var ReadTime_walkingRunning = 60*60
    var ReadTime_GPS = 60
    var ReadTime_Browser = 60*60
    var ReadTime_facebook = 60*60
    var ReadTime_Weather = 60*60
    var db:SQLiteDB!
    var formatter:DateFormatter = DateFormatter()
    var interval :TimeInterval  = 60*10
    var date_save :Date = Date()
    
    var data_temporary : [String] = [];

    
    func  Data_Filter()->Void
    {
        
    }
    
    func  Data_Orgnizer()->Void
    {
        
    }
    
    func  Data_Integrator()->Void
    {
        
    }
    
    func Read_Data_from_temporary()->Void
    {
        let name :String = ""
        
        db = SQLiteDB.sharedInstance()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
      let  data = db.query(sql: "select * from \(name) where isupload='false'")
        
        if data.count > 0 {
            print("upload start")
            var row = data[0]
            
            for i in 0...(data.count-1) {
                Thread.sleep(forTimeInterval: 0.1)
                row = data[i]
                let date =  row["time"]as?String
            }
        }
        
    }
    
    
    
}
