//
//  DataCollection_Model.swift
//  Cyber-I Data Management System
//
//  Created by guoao on 15/5/28.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation
import HealthKit
import UIKit
import CoreLocation


class DataCollection_Model :  NSObject,CLLocationManagerDelegate {
    
    var healthKitStore = HKHealthStore()
    let kUnknownString   = "Unknown"
    let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
    let lm: CLLocationManager! = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var time : Date = Date()
    var formatter:DateFormatter = DateFormatter()
    
    var db:SQLiteDB!
    var Sp =  Schedule_process()
    var sql :String = ""
    

    var req = NSMutableURLRequest(url: URL(string : "http://104.247.221.79/CyberI/View/Test/save_Data.jsp")!)
    var date_temp = ""
    var query: HKSampleQuery!
    func init_self() {
        
        formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 1000
        //  lm.startUpdatingLocation()
        
        db = SQLiteDB.sharedInstance()
        
        // db.execute("DELETE FROM ReadLog WHERE Data_type='HeartRate'")
        //db.execute("DELETE FROM HeartRate ")
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        print(latitude)
        print(longitude)
        time = Date()
        sql = "insert into GPS(latitude,longitude,time,isupload) values('\(latitude)','\(longitude)','\(formatter.string(from: time))','false')"
        db.execute(sql: sql)
        if(global_Data.GetWeather_switch)
        {
            GetWeatherDataFromGPS(latitude , longitude: longitude)
            global_Data.GetWeather_switch = false
        }
        Sp.Schedule_Upload_Data()
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }
    
 
    func Authorize() {
        
        
        let writeDataTypes: Set<HKSampleType> = self.dataTypesToWrite()
        let readDataTypes: Set<HKObjectType> = self.dataTypesToRead()
        
        let completion: ((Bool, NSError?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
           
        }
        
        self.healthKitStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes, completion: completion as! (Bool, Error?) -> Void)
    
        /*
        let healthKitTypesToRead = [
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
             HKQuantityType.categoryTypeForIdentifier(HKCategoryTypeIdentifierSleepAnalysis)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureDiastolic)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceCycling)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
             HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
             HKQuantityType.workoutType()
            ]
        let healthKitTypesToWrite =  [HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)]
        
        if !HKHealthStore.isHealthDataAvailable()
        {
            print("HealthKit is not available in this Device")
            return;
        }
        
        self.healthKitStore.requestAuthorizationToShareTypes(Set<NSObject>(arrayLiteral:healthKitTypesToWrite),  readTypes: Set<NSObject>(arrayLiteral: healthKitTypesToRead), completion: {
         (success, error) in
          if success {
          println("User completed authorisation request.")
         } else {
        println("The user cancelled the authorisation request. \(error)")
        }
        })
 */
        }
        
    fileprivate func dataTypesToWrite() -> Set<HKSampleType>
    {
        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType:  HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        let writeDataTypes: Set<HKSampleType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
        
        return writeDataTypes
    }
    
    


    
    
    fileprivate func dataTypesToRead() -> Set<HKObjectType>
    {
        let dietaryCalorieEnergyType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType:  HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType: HKQuantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let birthdayType: HKCharacteristicType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let biologicalSexType: HKCharacteristicType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        
        let readDataTypes: Set<HKObjectType> = [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
    HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
    HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
      HKQuantityType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)!,
     HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
      HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
       HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
        HKQuantityType.workoutType()
       ]
        
        return readDataTypes
    }
    
    
    
    func ReadHeartRate() {
       let data = db.query(sql: "select * from ReadLog where Data_type=?", parameters:["HeartRate"])
        
        if data.count > 0 {
            //获取最后一行数据显示
            let row = data[data.count - 1]
            // println(row["time"]?.asString())
            date_temp = (row["time"] as?String)!
        }
        else{
            // date_temp = "2014/01/01/00/00/01/GMT+9"
            date_temp = formatter.string(from: Date())
            self.db.execute(
                sql: "insert into ReadLog(Data_type,time) values('HeartRate','\(self.formatter.string(from: Date()))')")
            
        }
        
        let predicate_HeartRate: NSPredicate = HKQuery.predicateForSamples(withStart: formatter.date(from: date_temp), end: Date(), options: HKQueryOptions.strictEndDate)
        let typeOfHeart = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        query = HKSampleQuery(sampleType: typeOfHeart!, predicate: predicate_HeartRate, limit: 0, sortDescriptors: [sortDescriptor])
            { (query, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                else
                {
                    var i = results!.count
                    let unit1 = HKUnit(from: "count/min")
                      let result = results as? [HKQuantitySample]!
                    while(i>1)
                    {
                        i -= 1;
                        
                        var heart:HKQuantity = result![i-1].quantity
                        //  print("心率: ")
                        //  print(heart.doubleValueForUnit(unit1))
                        //  print(" 时间:")
                        //  print(results[i].startDate)
                        self.db.execute(
                            sql: "insert into HeartRate(count_per_min,time,isupload) values('\(heart.doubleValue(for: unit1))','\(self.formatter.string(from: results![i-1].startDate))','false')")
                        
                    }
                    if(results!.count>1)
                    {
                        self.db.execute(
                            sql: "insert into ReadLog(Data_type,time) values('HeartRate','\(self.formatter.string(from: Date()))')")
                    }
                }
        }
        healthKitStore.execute(query)
        
    }
    
    
    func ReadSleepAnalyze() {
        
       let data = db.query(sql: "select * from ReadLog where Data_type=?", parameters:["SleepAnalyze"])
        if data.count > 0 {
            //获取最后一行数据显示
            let row = data[data.count - 1]
            // println(row["time"]?.asString())
            date_temp = (row["time"] as?String)!
        }
        else{
            //date_temp = "2014/01/01/00/00/01/GMT+9"
            date_temp = formatter.string(from: Date())
            self.db.execute(
                sql: "insert into ReadLog(Data_type,time) values('SleepAnalyze','\(self.formatter.string(from: Date()))')")
        }
        
        let predicate_SleepAnalyze: NSPredicate = HKQuery.predicateForSamples(withStart: formatter.date(from: date_temp), end: Date(), options:  [])
        let typeOfSleepData = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.sleepAnalysis)
        query = HKSampleQuery(sampleType: typeOfSleepData!, predicate: predicate_SleepAnalyze, limit: 0, sortDescriptors: [sortDescriptor])
            { (query, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                else
                {
                    var i = results!.count
                    //  let unit1 = HKUnit(fromString: "count/min")
                    while(i>1)
                    {
                        i -= 1;
                        
                        var value = results![i-1] as! HKCategorySample
                        var sleep_type = (value.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        
                        self.db.execute(
                            sql: "insert into SleepAnalyze(sleep_category,time,end_time,isupload) values('\(sleep_type)','\(self.formatter.string(from: results![i-1].startDate))','\(self.formatter.string(from: results![i-1].endDate))','false')")
                    }
                    if(results!.count>1)
                    {
                        self.db.execute(
                            sql: "insert into ReadLog(Data_type,time) values('SleepAnalyze','\(self.formatter.string(from: Date()))')")
                    }
                }
        }
        healthKitStore.execute(query)
        
        
    }
    
    
    
    
    func ReadStep() {
    let data = db.query(sql: "select * from ReadLog where Data_type=?", parameters:["Step" as AnyObject])
        if data.count > 0 {
            //获取最后一行数据显示
            let row = data[data.count - 1]
            // println(row["time"]?.asString())
            date_temp = (row["time"] as?String)!
        }
        else{
            // date_temp = "2014/01/01/00/00/01/GMT+9"
            date_temp = formatter.string(from: Date())
            self.db.execute(
                sql: "insert into ReadLog(Data_type,time) values('Step','\(self.formatter.string(from: Date()))')")
            
        }
        
        let predicate_Step: NSPredicate = HKQuery.predicateForSamples( withStart: formatter.date(from: date_temp), end: Date(), options: HKQueryOptions.strictEndDate)
        let typeOfStep = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        query = HKSampleQuery(sampleType: typeOfStep!, predicate: predicate_Step, limit: 0, sortDescriptors: [sortDescriptor])
            { (query, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                else
                {
                    var i = results!.count
                    //  let unit1 = HKUnit(fromString: "count/min")
                      let result = results as? [HKQuantitySample]!
                    while(i>1)
                    {
                        i -= 1;
                        // print(results[i].quantity)
                        
                        // print(results[i].startDate)
                    
                        
                        self.db.execute(
                            sql: "insert into Step(Step,time,isupload) values('\(result![i-1].quantity)','\(self.formatter.string(from: results![i-1].startDate))','false')")
                        
                    }
                    if(results!.count>1)
                    {
                        self.db.execute(
                            sql: "insert into ReadLog(Data_type,time) values('Step','\(self.formatter.string(from: Date()))')")
                    }
                }
        }
        healthKitStore.execute(query)
        
    }
    
    
    
    func ReadwalkingRunning() {
     let  data = db.query(sql: "select * from ReadLog where Data_type=?", parameters:["walkingRunning" as AnyObject])
        if data.count > 0 {
            //获取最后一行数据显示
            let row = data[data.count - 1]
            // println(row["time"]?.asString())
            date_temp = (row["time"] as?String)!
        }
        else{
            //date_temp = "2014/01/01/00/00/01/GMT+9"
            date_temp = formatter.string(from: Date())
            self.db.execute(
                sql: "insert into ReadLog(Data_type,time) values('walkingRunning','\(self.formatter.string(from: Date()))')")
            
        }
        let predicate_walkingRunning: NSPredicate = HKQuery.predicateForSamples( withStart: formatter.date(from: date_temp), end: Date(), options: HKQueryOptions.strictEndDate)
        let typeOfwalkingRunning = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        query = HKSampleQuery(sampleType: typeOfwalkingRunning!, predicate: predicate_walkingRunning, limit: 0, sortDescriptors: [sortDescriptor])
            { (query, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                else
                {
                    var i = results!.count
                      let result = results as? [HKQuantitySample]!
                    
                    while(i>1)
                    {
                        i -= 1;
                        /*
                        print("distance: ")
                        print(results[i-1].quantity)
                        print(" 起始时间:")
                        print(results[i-1].startDate)
                        print(" 结束时间:")
                        println(results[i-1].endDate)
                        */
                        self.db.execute(
                            sql: "insert into walkingRunning(distance,time,isupload) values('\(result![i-1].quantity)','\(self.formatter.string(from: results![i-1].startDate))','false')")
                    }
                    if(results!.count>1)
                    {
                        self.db.execute(
                            sql: "insert into ReadLog(Data_type,time) values('walkingRunning','\(self.formatter.string(from: Date()))')")
                    }
                    
                }
        }
        healthKitStore.execute(query)
        
    }
    
    
    func ReadActiveEnergyBurned() {
       let data = db.query(sql: "select * from ReadLog where Data_type=?", parameters:["ActiveEnergyBurned" as AnyObject])
        
        if data.count > 0 {
            //获取最后一行数据显示
            let row = data[data.count - 1]
            // println(row["time"]?.asString())
            date_temp = (row["time"] as?String)!
            
        }
        else{
            // date_temp = "2014/01/01/00/00/01/GMT+9"
            date_temp = formatter.string(from: Date())
            self.db.execute(
                sql: "insert into ReadLog(Data_type,time) values('ActiveEnergyBurned','\(self.formatter.string(from: Date()))')")
        }
        
        let predicate_ActiveEnergyBurned: NSPredicate = HKQuery.predicateForSamples(withStart: formatter.date(from: date_temp), end: Date(), options: HKQueryOptions.strictEndDate)
        let typeOfActiveEnergyBurned = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let query = HKSampleQuery(sampleType: typeOfActiveEnergyBurned!, predicate: predicate_ActiveEnergyBurned, limit: 0, sortDescriptors: [sortDescriptor])
            { (query, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                else
                {
                    var i = results!.count
                      let result = results as? [HKQuantitySample]!
                    while(i>1)
                    {
                        i -= 1;
                        
                        self.db.execute(
                            sql: "insert into ReadActiveEnergyBurned(cal,time,isupload) values('\(result![i-1].quantity)','\(self.formatter.string(from: results![i-1].startDate))','false')")
                    }
                    if(results!.count>1)
                    {
                        self.db.execute(
                            sql: "insert into ReadLog(Data_type,time) values('ActiveEnergyBurned','\(self.formatter.string(from: Date()))')")
                    }
                }
        }
        
        
        healthKitStore.execute(query)
    }
    
    
    
    
    
    func ReadProfile() {
        let error:NSError?
        var age = 0
        do
            {
         let birthDay = try self.healthKitStore.dateOfBirth()
        
            
        
            let today = Date()
            let calendar = Calendar.current
            let differenceComponents = (Calendar.current as NSCalendar).components(.NSYearCalendarUnit, from: birthDay, to: today, options: NSCalendar.Options(rawValue: 0) )
            age = differenceComponents.year!
        
        if error != nil {
            print("Error reading Birthday: \(error)")
        }
        // 2. Read biological sex
        let biologicalSex:HKBiologicalSexObject? = try healthKitStore.biologicalSex();
        if error != nil {
            print("Error reading Biological Sex: \(error)")
        }
        // 3. Read blood type
        let bloodType:HKBloodTypeObject? = try healthKitStore.bloodType();
        if error != nil {
            print("Error reading Blood Type: \(error)")
        }
        
        print("\(age)")
        print(biologicalSexLiteral(biologicalSex?.biologicalSex))
        print(bloodTypeLiteral(bloodType?.bloodType))
        print(Date())
        
    }
    catch let error as NSError {
    
    }
    }

    func bloodTypeLiteral(_ bloodType:HKBloodType?)->String
    {
        
        var bloodTypeText = kUnknownString;
        
        if bloodType != nil {
            
            switch( bloodType! ) {
            case .aPositive:
                bloodTypeText = "A+"
            case .aNegative:
                bloodTypeText = "A-"
            case .bPositive:
                bloodTypeText = "B+"
            case .bNegative:
                bloodTypeText = "B-"
            case .abPositive:
                bloodTypeText = "AB+"
            case .abNegative:
                bloodTypeText = "AB-"
            case .oPositive:
                bloodTypeText = "O+"
            case .oNegative:
                bloodTypeText = "O-"
            default:
                break;
            }
            
        }
        return bloodTypeText;
    }
    
    func biologicalSexLiteral(_ biologicalSex:HKBiologicalSex?)->String
    {
        var biologicalSexText = kUnknownString;
        
        if  biologicalSex != nil {
            
            switch( biologicalSex! )
            {
            case .female:
                biologicalSexText = "Female"
            case .male:
                biologicalSexText = "Male"
            default:
                break;
            }
            
        }
        return biologicalSexText;
    }
    
    func lockStateChanged(_ state : Int){
        print(state)
        
        
        if(state == 0 )
        {
            //unlocked
            // println("device is unlocked")
            
            db = SQLiteDB.sharedInstance()
            formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
            let data = db.query(sql: "select * from Read_HealthKit_Schedule")
            var row = data[0]
            if data.count > 0{
                row = data[data.count - 1]
                let date = formatter.date(from: (row["Schedule_time"]as?String)!)
                if (Date().compare(date!).rawValue as Int  == 1)
                {
                    print("start reading from HealthKit")
                    
                    ReadSleepAnalyze()
                    ReadStep()
                    ReadHeartRate()
                    ReadwalkingRunning()
                    ReadActiveEnergyBurned()
                    global_Data.GetWeather_switch = true
                    
                    db.execute(sql: "DELETE FROM Read_HealthKit_Schedule")
                    db.execute(
                        sql: "insert into Read_HealthKit_Schedule(Schedule_time) values('\(self.formatter.string(from: Date(timeIntervalSinceNow: 60*60)))')")
                    print("has Readed from HealthKit ")
                }
                
            }
            
            
            
            
            //  Some_Test_func.start_upload_switch = false
            
        }
        else if (state == 1)
        {
            // Some_Test_func.start_upload_switch = true
            
            //locked
            //println("device is locked")
            //var json: JSON = JSON.nullJSON
            
            
            
            
        }
        
    }
    
    //wuhan  30.5810840000,114.3162000000
    // tokyo 35.7099131482209,139.515784273216


func GetWeatherDataFromGPS(_ latitude : Double,longitude : Double){
    let querywoeid =  YQL.query("SELECT * FROM geo.placefinder WHERE text=\"\(latitude),\(longitude)\"and gflags=\"R\"")
    let woeid_NSD = querywoeid?.value(forKeyPath: "query.results.Result") as! NSDictionary?
    let woeid  = woeid_NSD?.object(forKey: String("woeid")) as! String
    let blank = "  "
    let results = YQL.query("SELECT * FROM weather.forecast WHERE woeid=\(woeid)")
    var queryResults = results?.value(forKeyPath: "query.results.channel.item") as! NSDictionary?
    if queryResults != nil {
        let weatherCondition:String = queryResults?.value(forKeyPath: "condition.text")as! String
        let F :String =  queryResults?.value(forKeyPath: "condition.temp")as! String
        var C :Int = (Int(F))!
        C = (C-32)*5/9
        queryResults = results?.value(forKeyPath: "query.results.channel.astronomy") as! NSDictionary?
        let sunrise :String =  queryResults?.value(forKeyPath: "sunrise")as! String
        let sunset :String =  queryResults?.value(forKeyPath: "sunset")as! String
        queryResults = results?.value(forKeyPath: "query.results.channel.atmosphere") as!NSDictionary?
        let humidity :String =  queryResults?.value(forKeyPath: "humidity")as! String
        let pressure :String =  queryResults?.value(forKeyPath: "pressure")as! String
        let visibility :String =  queryResults?.value(forKeyPath: "visibility")as! String
        queryResults = results?.value(forKeyPath: "query.results.channel.location") as! NSDictionary?
        let city :String =  queryResults?.value(forKeyPath: "city")as! String
        let country :String =  queryResults?.value(forKeyPath: "country")as! String
        self.db.execute(
            sql: "insert into WeatherData(city,country,sunrise,sunset,humidity,pressure,visibility,temperature,weatherCondition,time,isupload) values('\(city)','\(country)','\(sunrise)','\(sunset)','\(humidity)','\(pressure)','\(visibility)','\(C) ℃','\(weatherCondition)','\(self.formatter.string(from: Date()))','false')")
        }
    }
    
    
    
}


