//
//  CtoS_HTTP.swift
//  Cyber-I Data Management System
//
//  Created by guoao on 15/5/23.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation
import UIKit


class Schedule_process {
    
    /*
    db.execute(
    "create table if not exists UploadLog(uid integer primary key,Data_type varchar(20),last_data_upload_time varchar(30),start_time varchar(30))")
    
    db.execute(
    "create table if not exists Schedule(uid integer primary key,Data_type varchar(20),Schedule_time varchar(30))")
    */
    
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
    var data = ""
    var randomVar :String = ""
    var req = NSMutableURLRequest(url: URL(string : "http://104.247.221.79/CyberI/View/Test/save_Data.jsp")!)
    func Schedule_Upload_Data()
    {
        db = SQLiteDB.sharedInstance()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        let data = db.query( "select * from Schedule_Upload_Data")
        var row = data[0]
        //let blank = "    "
        if data.count > 0{
            for i in 0...(data.count-1) {
                row =  data[i]
                //   date_temp = row["time"]!.asString()
                // println(row["Data_type"]!.asString() + blank + row["Schedule_time"]!.asString())
                let date =  formatter.date(from: (row["Schedule_time"]as?String)!)
                if (Date().compare(date!).rawValue as Int  == 1)
                {
                    switch row["Data_type"]as!String {
                    case "ReadHeartRate" :
                        self.ReadHeartRate(date!)
                        
                    case "ReadSleepAnalyze" :
                        self.ReadSleepAnalyze(date!)
                        
                    case "ReadStep" :
                        self.ReadStep(date!)
                        
                    case "ReadwalkingRunning" :
                        self.ReadwalkingRunning(date!)
                        
                    case "ReadActiveEnergyBurned" :
                        self.ReadActiveEnergyBurned(date!)
                        
                    case "GetWeatherDataFromGPS" :
                        self.GetWeatherDataFromGPS(date!)
                        
                    case "ReadGPS" :
                        self.ReadGPS(date!)
                        
                    case "ReadProfile" :
                        self.ReadProfile(date!)
                    default: break
                        
                    }
                }
                
            }
        }
        
    }
    
    
    func ReadHeartRate(_ date : Date )
    {
        print("ReadHeartRate")
        interval   = 60*30
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadHeartRate'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadHeartRate','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("HeartRate")
    }
    
    func ReadSleepAnalyze(_ date : Date )
    {
        print("ReadSleepAnalyze")
        interval   = 60*60*12
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadSleepAnalyze'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadSleepAnalyze','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("SleepAnalyze")
    }
    
    func ReadStep(_ date : Date )
    {
        print("ReadStep")
        interval   = 60*30
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadStep'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadStep','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("Step")
    }
    func ReadwalkingRunning(_ date : Date )
    {
        print("ReadwalkingRunning")
        interval   = 60*30
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadwalkingRunning'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadwalkingRunning','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("walkingRunning")
    }
    func ReadActiveEnergyBurned(_ date : Date )
    {
        print("ReadActiveEnergyBurned")
        interval   = 60*30
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute("DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadActiveEnergyBurned'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadActiveEnergyBurned','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("ReadActiveEnergyBurned")
    }
    func ReadProfile(_ date : Date )
    {
        print("ReadProfile")
        interval   = 60*60*24
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadProfile'")
        db.execute(
             "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadProfile','\(self.formatter.string(from: date_save))')")
        
    }
    func GetWeatherDataFromGPS(_ date : Date )
    {
        print("GetWeatherDataFromGPS")
        interval   = 60*60*1
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='GetWeatherDataFromGPS'")
        db.execute(
             "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('GetWeatherDataFromGPS','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("WeatherData")
    }
    func ReadGPS(_ date : Date )
    {
        print("ReadGPS")
        interval   = 60*30
        date_save  = Date(timeIntervalSinceNow: interval)
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db.execute( "DELETE FROM Schedule_Upload_Data WHERE Data_type='ReadGPS'")
        db.execute(
            "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadGPS','\(self.formatter.string(from: date_save))')")
        HTTP_Upload_Data_from_DB("GPS")
    }
    
    func HTTP_Upload_Data_from_DB(_ db_name :String)
    {
        db = SQLiteDB.sharedInstance()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
       let data = db.query( "select * from \(db_name) where isupload='false'")
        
        
        if data.count > 0 {
            print("upload start")
            var row = data[0]
            
            for i in 0...(data.count-1) {
                Thread.sleep(forTimeInterval: 0.1)
                //这块数据量大了有可能挂   是否要判断限定个数字，比如i=800， 大于800就退出，下次循环间隔再继续
                if(i<1000)
                {
                    randomVar = String(arc4random_uniform(1000))
                    row = data[i]
                    let date =  row["time"]as?String
                    req = NSMutableURLRequest(url: URL(string : "http://192.168.199.217:8080/CyberI/View/Test/save_Data.jsp")!)
                    req.httpMethod = "POST"

                    do {
                       print( JSONSerialization.isValidJSONObject(row))

                    let data : Data! = try? JSONSerialization.data(withJSONObject: row, options: [])
                    let str = NSString(data:data, encoding: String.Encoding.utf8.rawValue)!
                        //var j : String =
                    //let key = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00] as [UInt8]
                    //     let iv = Cipher.randomIV(AES.blockSize)
                    //       let encrypted = Cipher.AES(key: key, iv: iv, blockMode: .CBC).encrypt(j as! [UInt8])
                    /* var s = "00000000001C0000800100000101010B8000800108A0100000000001C000080010000010010B80008001008A01000000000C0000800100000101010B80008001008A010000000001C000080010000101010B80008001008A0100000000001C0000801000001010B80008001008A0100000000001C00000100000000"
                    */
                        print(str)
                    req.httpBody = NSString(string: "json=\(str )&random=\(randomVar)&username=\(global_Data.Current_User)&Description=\(db_name)&md5=\(randomVar.md5_s()!)").data(using: String.Encoding.utf8)
                    }catch {
                    }
                    NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue.main) { (resp: URLResponse?, data: Data?, error: Error?) -> Void in
                        if let d = data{
                            //                    var text_return = NSString(data: d, encoding: NSUTF8StringEncoding)! as String
                            //                    println(text_return)
                            
                            self.db.execute(
                                //     "update \(db_name) set isupload='true' where isupload='false' and time='\(date)'")
                                sql: "update \(db_name) set isupload='true' where time='\(date)' and isupload='false'")
                        
                            
                        }
                        else
                        {
                            print(error)
                        }
                    }
                }
                    
                else{
                    print("over 1000 items, return")
                    return
                }
            }
        }
        print("upload complete, return")
    }
    
    
    
    func init_Schedule_Upload_Data()
    {
        
        let db = SQLiteDB.sharedInstance()
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        db?.execute(
          "create table if not exists Schedule_Upload_Data(uid integer primary key,Data_type varchar(20),Schedule_time varchar(30))")
        db?.execute(
           "create table if not exists Default_data_schedule_time(uid integer primary key,Data_type varchar(20),time_interval varchar(30))")
        db?.execute(
            "create table if not exists GPS(uid integer primary key,latitude varchar(20),longitude varchar(20),time varchar(30),isupload varchar(5))")
        db?.execute(
             "create table if not exists ReadLog(uid integer primary key,Data_type varchar(20),time varchar(30))")
        db?.execute(
            "create table if not exists HeartRate(uid integer primary key,count_per_min varchar(20),time varchar(30),isupload varchar(5))")
        db?.execute(
        "create table if not exists Step(uid integer primary key,Step varchar(20),time varchar(30),isupload varchar(5))")
        db?.execute(
            "create table if not exists walkingRunning(uid integer primary key,distance varchar(20),time varchar(30),isupload varchar(5))")
        db?.execute(
            "create table if not exists ReadActiveEnergyBurned(uid integer primary key,cal varchar(20),time varchar(30),isupload varchar(5))")
        
        db?.execute(
            "create table if not exists SleepAnalyze(uid integer primary key,sleep_category varchar(20),time varchar(30),end_time varchar(30),isupload varchar(5))")
        
        db?.execute(
             "create table if not exists UploadLog(uid integer primary key,Data_type varchar(20),last_data_upload_time varchar(30),start_time varchar(30))")
        
        db?.execute(
             "create table if not exists WeatherData(uid integer primary key,city varchar(20),country varchar(20),sunrise varchar(10),sunset varchar(10),humidity varchar(10),pressure varchar(10),visibility varchar(10),temperature varchar(10),weatherCondition varchar(20),time varchar(30),isupload varchar(5))")
        
        db?.execute(
            "create table if not exists logIn_Info(uid integer primary key,username varchar(20),login_Time varchar(30))")
        
        db?.execute(
            "create table if not exists Read_HealthKit_Schedule(uid integer primary key,Schedule_time varchar(30))")
        
        
        var data = db?.query( "select * from Read_HealthKit_Schedule")
        if (data?.count)! < 1{
            
            db?.execute("DELETE FROM Read_HealthKit_Schedule ")
            db?.execute(
                 "insert into Read_HealthKit_Schedule(Schedule_time) values('\(self.formatter.string(from: Date()))')")
        }
        
        
        data = db?.query("select * from Schedule_Upload_Data")
        if (data?.count)! < 1{
            
            db?.execute( "DELETE FROM Schedule_Upload_Data ")
            
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadHeartRate','\(self.formatter.string(from: Date()))')")
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadSleepAnalyze','\(self.formatter.string(from: Date()))')")
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadStep','\(self.formatter.string(from: Date()))')")
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadwalkingRunning','\(self.formatter.string(from: Date()))')")
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadActiveEnergyBurned','\(self.formatter.string(from: Date()))')")
            db?.execute(
                 "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadProfile','\(self.formatter.string(from: Date()))')")
            db?.execute(
                sql: "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('GetWeatherDataFromGPS','\(self.formatter.string(from: Date()))')")
            db?.execute(
                sql: "insert into Schedule_Upload_Data(Data_type,Schedule_time) values('ReadGPS','\(self.formatter.string(from: Date()))')")
            
        }
        
    }
    
    func delete_all_data()
    {
        db = SQLiteDB.sharedInstance()
        db.execute( "DELETE FROM Schedule_Upload_Data ")
        db.execute("DELETE FROM GPS ")
        db.execute("DELETE FROM HeartRate ")
        db.execute("DELETE FROM Step ")
        db.execute( "DELETE FROM walkingRunning ")
        db.execute( "DELETE FROM ReadActiveEnergyBurned ")
        db.execute( "DELETE FROM SleepAnalyze ")
        db.execute( "DELETE FROM UploadLog ")
        db.execute("DELETE FROM WeatherData ")
        db.execute( "DELETE FROM Default_data_schedule_time ")
        db.execute( "DELETE FROM ReadLog ")
        db.execute( "DELETE FROM logIn_Info ")
        
        
    }
    
    //
    //    func test_update()
    //    {
    //        db = SQLiteDB.sharedInstance()
    //        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
    //        data = db.query("select * from Step where isupload='false'")
    //
    //
    //        if data.count > 0 {
    //            println("upload start")
    //            var row : SQLRow
    //
    //            for i in 0...(data.count-1) {
    //                NSThread.sleepForTimeInterval(0.1)
    //                //这块数据量大了有可能挂   是否要判断限定个数字，比如i=800， 大于800就退出，下次循环间隔再继续
    //
    //                randomVar = String(arc4random_uniform(1000))
    //                row = data[i] as SQLRow
    //                let date  = row["time"]!.asString()
    //                println(date)
    //                self.db.execute(
    //                    "update Step set isupload='true' where time='\(date)' and isupload='false'")
    //
    //
    //            }
    //        }
    //
    //
    //    }
    
    
}
