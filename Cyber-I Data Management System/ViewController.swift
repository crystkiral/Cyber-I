//
//  ViewController.swift
//  HTTPtest
//
//  Created by guoao on 15/5/23.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import UIKit


class ViewController: UIViewController , FBSDKLoginButtonDelegate{
    
    override func viewDidLoad() {
    super.viewDidLoad()
   let sp =  Schedule_process()
    sp.delete_all_data()
    sp.init_Schedule_Upload_Data()
    }
    /*
    var db:SQLiteDB!
    db = SQLiteDB.sharedInstance()
    let data = db.query("select * from ReadLog where Data_type=?", parameters:["walkingRunning"])
    var date_temp = ""
    if data.count > 0 {
    //获取最后一行数据显示
    let random  =  arc4random_uniform(1000)
    let randomVar : String = String(random)
    let row = data[data.count - 1] as SQLRow
    var req = NSMutableURLRequest(URL: NSURL(string : "http://172.20.10.2:8080/CyberI/View/Test/save_Data.jsp")!)
    req.HTTPMethod = "POST"
    req.HTTPBody = NSString(string: "json=\(Convert_DB_to_JSON(row.data) )&random=\(randomVar)&Description=()&md5=\(randomVar.md5())").dataUsingEncoding(NSUTF8StringEncoding)
    NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) { (resp: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
    if let d = data{
    var text_return = NSString(data: d, encoding: NSUTF8StringEncoding)! as String
    println(text_return)
    
    }
    else
    {
    println(error)
    }
    }
    }
    */
    
    // facebook button
    /*
    if (FBSDKAccessToken.currentAccessToken() != nil)
    {
    // User is already logged in, do work such as go to next view controller.
    }
    else
    {
    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    self.view.addSubview(loginView)
    loginView.center = self.view.center
    loginView.readPermissions = ["public_profile", "email", "user_friends"]
    loginView.delegate = self
    
    }
    */
    // Do any additional setup after loading the view, typically from a nib.
    
    //         var str = NSString(contentsOfURL: NSURL(string: "http://Cyber-I.org" )!, encoding: NSUTF8StringEncoding, error: nil)
    //        println(str)
    //        var resp: NSURLResponse?
    //        var error: NSError?
    //        var data = NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: NSURL(string : "http://Cyber-I.org")!), returningResponse: &resp, error: &error)
    //        if let d = data{
    //      //  println(NSString(data: d, encoding: NSUTF8StringEncoding))
    //        }
    //        if let r = resp{
    //            println(r)
    //        }
    
    //        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string : "http://localhost:8080/CyberI/View/Test/process.jsp?name=\()")!), queue: NSOperationQueue()) { (resp: NSURLResponse!, data: NSData!,error: NSError!) -> Void in
    //            if let e = error{
    //                println("发生了错误！")
    //            }
    //            else
    //            {
    //                println(NSString(data: data, encoding: NSUTF8StringEncoding))
    //            }
    //
    //        }
    //
    //        if let e = error{
    //            println(e)
    //            println("无法连接网络")
    //        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet var fbLoginView: UILabel!
    @IBOutlet var name: UITextField!
    @IBAction func connect(sender: UIButton) {
        
        //GET
        //        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: NSURL(string : "http://localhost:8080/CyberI/View/Test/process.jsp?name=\(name.text)")!), queue: NSOperationQueue()) { (resp: NSURLResponse!, data: NSData!,error: NSError!) -> Void in
        //            if let d = data{
        //                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
        //                    self.text.text = NSString(data: data,encoding: NSUTF8StringEncoding)! as String
        //
        //                                   })
        //
        //            }
        //
        //        }
        
        //POST
        
        var req = NSMutableURLRequest(url: NSURL(string : "http://localhost:8080/CyberI/View/Test/process.jsp")! as URL)
        req.httpMethod = "POST"
        req.HTTPBody = NSString(string: "name=\(name.text)&md5=\(name.text!.md5_s())").dataUsingEncoding(NSUTF8StringEncoding)
        
        NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue.mainQueue) { (resp: URLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if let d = data{
                NSString(data: d, encoding: NSUTF8StringEncoding)! as String
                print( self.name.text!.md5_s())
                
            }
        }
        
        
        
        
        
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
}
