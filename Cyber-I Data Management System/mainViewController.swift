//
//  ViewController.swift
//  Cyber-I Data Management System
//
//  Created by guoao on 15/5/22.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation
import HealthKit
import UIKit
import CoreLocation
import CoreFoundation


class mainViewController: UIViewController , CLLocationManagerDelegate {
    
    var timer : Timer?
    var ReadTime_HeartRate = 60*60
    var ReadTime_Step = 60*60
    var ReadTime_SleepData = 60*60*24
    var ReadTime_ActiveEnergyBurned = 60*60
    var ReadTime_walkingRunning = 60*60
    var ReadTime_GPS = 60
    var ReadTime_Browser = 60*60
    var ReadTime_facebook = 60*60
    var ReadTime_Weather = 60*60
    var DCM = DataCollection_Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 180, target : self, selector : #selector(mainViewController.Main_Queue), userInfo: nil, repeats : true)
        DCM.init_self()
        DCM.Authorize()
        DCM.lm.startUpdatingLocation()
        let objc: objectC = objectC()
        objc.registerAppforDetectLockState()

        /*
        var objc: objectC = objectC()
        objc.registerAppforDetectLockState()
        */
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    func Main_Queue()
    {
        DCM.lm.startUpdatingLocation()
        //  objc.registerAppforDetectLockState();
        
        
    }
    
    
    
}

