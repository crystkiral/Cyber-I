//
//  RegisterController.swift
//  HTTPtest
//
//  Created by guoao on 15/5/25.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

import Foundation

class RegisterController: UIViewController ,UITextFieldDelegate{
    
    var Message_return :String = " "
    
    @IBOutlet var birthdayPicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        birthdayPicker.datePickerMode = UIDatePickerMode.date
        // birthdayPicker.minimumDate = NSDate()
        birthdayPicker.addTarget(self, action:#selector(RegisterController.datePickerValueChange(_:)), for: UIControlEvents.valueChanged)
        birthday.tag = 1001
        birthday.delegate = self
        birthday.text = "1900年1月1日"
        username.delegate = self
        email.delegate = self
        password.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    
    
    @IBOutlet var birthday: UITextField!
    
    @IBAction func Register(_ sender: UIButton) {
        var connect_success = false
        if check_register()
        {
            print("start register")
            let md5_check :String = username.text! + email.text! + password.text! + birthday.text! + "CyberI_register_ID"
    
    //    let alertController = UIAlertController(title: "Notice" ,message: "Incorrect" ,preferredStyle: .Alert)
    //    presentModalViewController:svc(alertController, animated:true, completion: nil)
    //
            
            let req = NSMutableURLRequest(url: URL(string : "http://192.168.199.217:8080/CyberI/View/Test/register.jsp")!)
            req.timeoutInterval = 5000
            req.httpMethod = "POST"
            req.httpBody = NSString(string: "username=\(username.text!)&email=\(email.text!)&password=\(password.text!)&birthday=\(birthday.text!)&md5=\(md5_check.md5_s()!)").data(using: String.Encoding.utf8)

            
            NSURLConnection.sendAsynchronousRequest(req as URLRequest, queue: OperationQueue.main) { (resp: URLResponse?, data: Data?, error: Error?) -> Void in
                if let d = data{
                    var text_return = NSString(data: d, encoding: String.Encoding.utf8.rawValue)! as String
                    print(text_return)
                    if(text_return.range(of: "Register success!") != nil)
                    {
                        //                        self.Message_return = "Register success!"
                        //                        self.showAlertController(self.Message_return, action: 1)
                        //do return to main view
                        let myStoryBoard = self.storyboard
                        let anotherView: UIViewController = (myStoryBoard?.instantiateViewController(withIdentifier: "welcomeView"))!
                        self.present(anotherView, animated: true, completion: nil)
                    }
                    else
                    {
                        let range = ((text_return.characters.index(text_return.startIndex, offsetBy: +3)) ..< (text_return.characters.index(text_return.endIndex, offsetBy: -1)))
                        self.Message_return = text_return.substring(with: range)
                        self.showAlertController(self.Message_return)
                        
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
    
    func  check_register() -> Bool
    {
        if (username.text != nil && email.text != nil && password != nil && birthday != nil)
        {
            let match = email.text!.range(of: "^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$", options: .regularExpression)
            print(match?.isEmpty)
            if((match?.isEmpty) != nil){
                if
                    (password.text!.lengthOfBytes(using: String.Encoding()) < 8)
                {
                    
                    print("Password is too short!")
                    Message_return = "Password is too short!"
                    self.showAlertController(Message_return)
                    return false
                    
                }
                    
                    
                else {
                    return true
                }
            }
            else
            {
                print("Email is incorrect!")
                Message_return = "Email is incorrect!"
                self.showAlertController(Message_return)
                return false
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
        // alertController.addAction(actionNo)
        
        present(alertController, animated:true, completion: nil)
        
    }
    
    func datePickerValueChange (_ sender : UIDatePicker)
    {
        let selectedDate : Date = sender.date
        let formatter : DateFormatter = DateFormatter()
        
        formatter.dateFormat = "yyyy年MM月dd日"
        let dateString  =  formatter.string(from: selectedDate)
        self.birthday.text = dateString
        
        
    }
    
    func  textFieldShouldBeginEditing(_ textField : UITextField) ->Bool
    {
        if(textField.tag != 1001)
        {
            if(self.birthdayPicker.isHidden == false)
            {
                self.birthdayPicker.isHidden = true
                
            }
            return true
        }
        if(self.birthdayPicker.isHidden == true)
        {
            self.username.resignFirstResponder()
            self.email.resignFirstResponder()
            self.password.resignFirstResponder()
        }
        
        self.birthdayPicker.isHidden = false;
        
        return false
    }
    
    /*
    //2.执行函数使用UIAlertView
    func showAlert(){
    
    var title = "欢迎来到美空studio"
    var msgMessage = "是否现在去注册"
    var alert:UIAlertView = UIAlertView()
    
    alert.title = title
    alert.message = msgMessage
    alert.addButtonWithTitle("马上去注册")
    alert.addButtonWithTitle("以后去注册")
    alert.show()
    }
    */
}
