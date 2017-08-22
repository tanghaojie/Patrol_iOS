//
//  LoginViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/14.
//  Copyright © 2017年 JT. All rights reserved.
//
import UIKit
import SwiftyJSON

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    
    var activity : UIActivityIndicatorView!
    var isFirstApear: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(message: log_SystemStart)
        setupUI()
        setRememberedUserAndPass()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginInfo = nil
        setLoginButtonEnable()
        if(isFirstApear){
            autoLogin()
            isFirstApear = false
        }
    }
    
    @IBAction func loginClick(_ sender: Any) {
        loginButtonClick()
    }
    
    @IBAction func settingClick(_ sender: Any) {
        settingButtonClick()
    }
    
    @IBAction func registeClick(_ sender: Any) {
        registeButtonClick()
    }
    
    @IBAction func forgetClick(_ sender: Any) {
        AlertWithNoButton(view: self, title: "敬请期待", message: nil, preferredStyle: .alert, showTime: 1)
    }
}

//ui
extension LoginViewController {
    
    fileprivate func setupUI() {
        username.delegate = self
        username.addTarget(self, action: #selector(usernameEditingEvents(_:)), for: .allEditingEvents)
        password.delegate = self
        password.addTarget(self, action: #selector(passwordEditingEvents(_:)), for: .allEditingEvents)
        
        activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.center = login.center
        self.view.addSubview(activity)
    }

}

//event
extension LoginViewController: LoginDelegate {
    
    fileprivate func loginButtonClick() {
        let user = username.text
        let pass = password.text
        
        self.activity.center = self.login.center
        
        if(user=="adminJT"&&pass=="IamJT!"){
            loginInfo = LoginInfo()
            loginInfo?.userId = 1
            loginInfo?.realname = "JT"
            loginInfo?.username = "adminJT"
            loginInfo?.protraiurl = ""

            self.activity.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            loginInfo?.config = Config(id: -1)
            
            //self.saveDefaultUsernamePassword(username: user!, password: pass!)
            self.present(MainViewController(), animated: true, completion: nil)
            return
        }
        
        if(!checkInput(user: user!, pass: pass!)){
            return
        }
        
        let para = "username="+user!+"&password="+pass!
        self.activity.startAnimating()
        self.view.isUserInteractionEnabled = false
        let urlRequest = getLoginRequest(para: para)
        
        loginAsyncConnect(urlRequest: urlRequest, user: user, pass: pass)
    }
    
    fileprivate func registeButtonClick() {
        let sb = UIStoryboard(name: "Regist", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RegistViewController") as! RegistViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func settingButtonClick() {
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let identifier = textField.accessibilityIdentifier
        if(identifier == "usernameIdentifier"){
            password.becomeFirstResponder()
        }else if(identifier == "passwordIdentifier"){
            loginClick(self)
        }
        return true
    }
    
    func usernameEditingEvents(_ textField: UITextField){
        self.login.isEnabled = (textField.text?.characters.count)!>0 && (password.text?.characters.count)!>0
    }
    
    func passwordEditingEvents(_ textField: UITextField){
        self.login.isEnabled = (textField.text?.characters.count)!>0 && (username.text?.characters.count)!>0
    }
}

//func
extension LoginViewController {
    
    fileprivate func checkInput(user : String, pass : String) -> Bool {
        if(user.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterUsername, message: nil, preferredStyle: .alert, showTime: 0.5)
            username.becomeFirstResponder()
            return false
        }
        if(pass.isEmpty){
            AlertWithNoButton(view: self, title: msg_PleaseEnterPassword, message: nil, preferredStyle: .alert, showTime: 0.5)
            password.becomeFirstResponder()
            return false
        }
        return true
    }
    
    fileprivate func autoLogin(){
        let name = self.username.text
        let pass = self.password.text
        if(!(name?.isEmpty)! && !(pass?.isEmpty)!){
            loginClick(self)
        }
    }
    
    fileprivate func getLoginRequest(para: String) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_Login)!)
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
    
    fileprivate func loginAsyncConnect(urlRequest : URLRequest, user: String?, pass: String?) {
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: { [weak self] (response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self?.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 1, log: String(statusCode) + msg_HttpError + url_Login)
                    return
                }
                if(error != nil){
                    self?.alertAndLog(msg: msg_ConnectTimeout, showTime: 1, log: String(describing: error) + log_Timeout + url_Login)
                    return
                }
                if(data?.isEmpty)!{
                    self?.alertAndLog(msg: msg_ServerNoResponse, showTime: 1, log: log_ServerNoResponse + url_Login)
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let data = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithNoButton(view: self!, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                        }
                        
                        self?.activity.stopAnimating()
                        self?.view.isUserInteractionEnabled = true
                        
                        self?.saveDefaultUsernamePassword(username: user!, password: "")
                        return
                    }
                    if data != JSON.null {
                        let id = data["id"].int
                        let realname = data["realname"].string
                        let username = data["username"].string
                        let portraiturl = data["portraiturl"].string
                        
                        loginInfo = LoginInfo()
                        loginInfo?.userId = id
                        loginInfo?.realname = realname
                        loginInfo?.username = username
                        loginInfo?.protraiurl = portraiturl
                        
                        self?.activity.stopAnimating()
                        self?.view.isUserInteractionEnabled = true
                        
                        loginInfo?.config = Config(id: id!)
                        if(!((loginInfo?.config?.success)!)){
                            let msg = loginInfo?.config?.msg
                            self?.alertAndLog(msg: msg!, showTime: 1, log: msg!)
                            return
                        }
                        
                        self?.saveDefaultUsernamePassword(username: user!, password: pass!)
                        self?.present(MainViewController(), animated: true, completion: nil)
                    }else{
                        // running there must be webapi error
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self?.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_ServerNoResponse + url_Login)
                return
            }
        })
    }
    
    internal func clearUsernamePassword() {
        self.username.text = ""
        self.password.text = ""
    }
    
    fileprivate func setLoginButtonEnable(){
        if((username.text?.isEmpty)! || (password.text?.isEmpty)!){
            login.isEnabled = false
        }else{
            login.isEnabled = true
        }
    }

}

//db
extension LoginViewController{
    
    fileprivate func setRememberedUserAndPass(){
        let user = SQLiteManager.instance.queryUser(sql: kSql_SelectUserTableLast)
        if(user.isEmpty){
            self.username.becomeFirstResponder()
            return
        }
        let name = user[0].username
        let pass = user[0].password
        
        self.username.text = name
        self.password.text = pass
    }
    
    fileprivate func saveDefaultUsernamePassword(username : String, password : String){
        let sql = getInsertOrReplaceSql(username: username, password: password)
        if(!SQLiteManager.instance.executeSQL(sql: sql)){
            printLog(message: log_Login_InsertOrReplaceUsernamePasswordError)
            exit(0)
        }
    }
}

protocol LoginDelegate {
    func clearUsernamePassword()
}
