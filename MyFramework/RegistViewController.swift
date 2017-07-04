//
//  RegistViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/22.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit
import SwiftyJSON

class RegistViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passconfirm: UITextField!
    @IBOutlet weak var realname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var organization: UITextField!
    @IBOutlet weak var department: UITextField!
    @IBOutlet weak var remark: UITextView!
    @IBOutlet weak var remarkPlaceholder: UILabel!
    
    @IBOutlet weak var btnRegist: UIButton!
    
    var activity : UIActivityIndicatorView!
     
    let registModel: RegistModel = RegistModel()

    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func viewClick(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func regist(_ sender: Any) {
        registButtonClick()
    }

    @IBAction func back(_ sender: Any) {
        backButtonClick()
    }
        
}

//event
extension RegistViewController{
    
    fileprivate func registButtonClick(){
        registModel.username = self.username.text
        registModel.password = self.password.text
        registModel.confirmPassword = self.passconfirm.text
        registModel.realname = self.realname.text
        registModel.phone = self.phone.text
        registModel.organization = self.organization.text
        registModel.department = self.department.text
        registModel.remark = self.remark.text
        
        if(!checkInput(registModel: registModel)){
            return
        }
        
        let para = "username=\(registModel.username!)&password=\(registModel.password!)&realname=\(registModel.realname!)&phone=\(registModel.phone!)&organization=\(registModel.organization!)&department=\(registModel.department!)&remark=\(registModel.remark!)"
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let urlRequest = getRegistRequest(para: para)
        
        registAsyncConnect(urlRequest: urlRequest)
    }
    
    fileprivate func backButtonClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.remarkPlaceholder.isHidden = true
        return true
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if(remark.text.isEmpty){
            self.remarkPlaceholder.isHidden = false
        } else {
            self.remarkPlaceholder.isHidden = true
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.accessibilityIdentifier == "newuserIdentifier" && !((username.text?.isEmpty)!)){
            let para = "username=\(username.text!)"
            let urlRequest = getUsernameUniqueCheckRequest(para: para)
            usernameUniqueCheck(urlRequest: urlRequest)
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let identifier = textField.accessibilityIdentifier
        if(identifier == "newuserIdentifier"){
            self.password.becomeFirstResponder()
        }else if(identifier == "passIdentifier"){
            self.passconfirm.becomeFirstResponder()
        }else if(identifier == "confirmPassIdentifier"){
            self.realname.becomeFirstResponder()
        }else if(identifier == "realnameIdentifier"){
            self.phone.becomeFirstResponder()
        }else if(identifier == "phoneIdentifier"){
            self.organization.becomeFirstResponder()
        }else if(identifier == "organizationIdentifier"){
            self.department.becomeFirstResponder()
        }else if(identifier == "departmentIdentifier"){
            self.department.resignFirstResponder()
        }
        return true
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
}

//func
extension RegistViewController{
    
    fileprivate func checkInput(registModel: RegistModel) -> Bool {
        if(registModel.username?.isEmpty)!{
            AlertWithNoButton(view: self, title: msg_PleaseEnterNewUsername, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(registModel.password?.isEmpty)!{
            AlertWithNoButton(view: self, title: msg_PleaseEnterPassword, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(registModel.confirmPassword?.isEmpty)!{
            AlertWithNoButton(view: self, title: msg_PleaseEnterConfirmPassword, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(registModel.password != registModel.confirmPassword){
            AlertWithNoButton(view: self, title: msg_PasswordDifferentBetweenInputs, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(registModel.realname?.isEmpty)!{
            AlertWithNoButton(view: self, title: msg_PleaseEnterRealname, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        if(registModel.phone?.isEmpty)!{
            AlertWithNoButton(view: self, title: msg_PleaseEnterPhone, message: nil, preferredStyle: .alert, showTime: 0.5)
            return false
        }
        return true
    }
    
    fileprivate func getRegistRequest(para: String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_Regist)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        return urlRequest
    }
    
    fileprivate func getUsernameUniqueCheckRequest(para: String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_RegistUsernameUniqueCheck)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.httpBody = para.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        return urlRequest
    }
    
    fileprivate func alertAndLog(msg: String, showTime: TimeInterval, log: String){
        AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: showTime)
        printLog(message: log)
        
        self.activity.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    fileprivate func registAsyncConnect(urlRequest : URLRequest){
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 1, log: String(statusCode) + msg_HttpError + url_Regist)
                    return
                }
                if(error != nil){
                    self.alertAndLog(msg: msg_ConnectTimeout, showTime: 1, log: String(describing: error) + log_Timeout + url_Regist)
                    return
                }
                if(data?.isEmpty)!{
                    self.alertAndLog(msg: msg_ServerNoResponse, showTime: 1, log: log_ServerNoResponse + url_Regist)
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            //AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                            AlertWithUIAlertAction(view: self, title: msg_Remind, message: msg, preferredStyle: .alert ,
                                                   uiAlertAction: UIAlertAction(title: msg_OK, style: UIAlertActionStyle.default, handler: nil))
                        }
                        self.activity.stopAnimating()
                        self.view.isUserInteractionEnabled = true

                        return
                    }
                    
                    AlertWithUIAlertAction(view: self, title: msg_Remind, message: msg_RegistSuccess, preferredStyle: .alert ,
                                           uiAlertAction: UIAlertAction(title: msg_OK, style: UIAlertActionStyle.default, handler: {
                                            (alertAction: UIAlertAction) -> Void in
                                                self.delegate?.clearUsernamePassword()
                                                self.dismiss(animated: true, completion: nil)
                                           }))
                    
                    self.activity.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }else{
                    // running there must be webapi error
                }
            }else{
                self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_ServerNoResponse + url_Login)
                return
            }
        })
    }
    
    fileprivate func usernameUniqueCheck(urlRequest : URLRequest){
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode == 200 && error == nil && !(data?.isEmpty)!){
                    let json = JSON(data : data!)
                    let nStatus = json["status"].int
                    let nMsg = json["msg"].string
                    
                    if let status = nStatus{
                        if(status != 0){
                            if let msg = nMsg{
                                self.username.layer.borderColor = UIColor.red.cgColor
                                self.username.layer.borderWidth = 1
                                AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                                return
                            }
                        }
                    }
                }
            }
            self.username.layer.borderColor = UIColor.clear.cgColor
        })
    }

}

//
extension RegistViewController : UITextViewDelegate , UITextFieldDelegate {
    
    fileprivate func setupUI(){
        self.username.delegate = self
        self.password.delegate = self
        self.passconfirm.delegate = self
        self.realname.delegate = self
        self.phone.delegate = self
        self.organization.delegate = self
        self.department.delegate = self
        self.remark.delegate = self
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.center = btnRegist.center
        self.view.addSubview(activity)
    }
    

 
}
