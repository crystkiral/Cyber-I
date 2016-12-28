//
//  LoginController.swift
//  HTTPtest
//
//  Created by guoao on 15/5/25.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation

class LoginController: UIViewController {
    var Message_return :String = " "
    
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
        
        var connect_success = false
        if check_login()
        {
            print("start login")
            var md5_check :String = username.text! + password.text! + "CyberI_login_ID"
            var req = NSMutableURLRequest(url: URL(string : "http://192.168.199.217:8080/CyberI/View/Test/login.jsp")!)
            req.timeoutInterval = 5000
            req.httpMethod = "POST"
            req.httpBody = NSString(string: "username=\(username.text!)&password=\(password.text!)&md5=\(md5_check.md5_s()!)").data(using: String.Encoding.utf8)
            
            NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue.main) { (resp: URLResponse?, data: Data?, error: Error?) -> Void in
                
                if let d = data{
                    var text_return = NSString(data: d, encoding: String.Encoding.utf8.rawValue)! as String
                    print(text_return)
                    if(text_return.range(of: "LogIn success!") != nil)
                    {
                        //do return to next view
                        var db:SQLiteDB!
                        db = SQLiteDB.sharedInstance()
                         var formatter:DateFormatter = DateFormatter()
                         formatter.dateFormat = "yyyy/MM/dd/HH/mm/ss/z"
                        db.execute(
                            sql: "insert into logIn_Info(username,login_Time) values('\(self.username.text)','\(formatter.string(from: Date()))')")
                        global_Data.Current_User = self.username.text!
                        let myStoryBoard = self.storyboard
                        let anotherView: UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "mainView"))!;                        self.present(anotherView, animated: true, completion: nil)
                        
                        
                    }
                    else
                    {
                        
                        self.showAlertController("Username or Password was wrong!")
                        
                    }
                    connect_success = true
                    
                }
                if(connect_success == false )
                {
                    self.showAlertController("Server connection error")
                    
                }
            }
            
            
        }
        
    }
    
    func  check_login() -> Bool
    {
        if username.text != nil  && password.text != nil
        {
            if
                (password.text!.lengthOfBytes(using: String.Encoding()) < 8) || (username.text!.lengthOfBytes(using: String.Encoding()) < 1)
            {
                
                print("Password is too short!")
                Message_return = "Username or Password is too short!"
                self.showAlertController(Message_return)
                return false
                
            }
                
                
            else {
                return true
            }
            
        }
            
        else
        {return false
        }
    }
    
    
    
    func showAlertController(_ s :String){
        
        let msgTitle = " "
        let msgMessage :String = s
        let btnYes="OK"
        
        
        let alertController = UIAlertController(title:msgTitle,message:msgMessage,preferredStyle: .alert)
        let actionYes = UIAlertAction(title:btnYes,style: .default){ action in
            
            
        }
        alertController.addAction(actionYes)
        
        
        present(alertController, animated:true, completion: nil)
        
    }
    
    
    
}
