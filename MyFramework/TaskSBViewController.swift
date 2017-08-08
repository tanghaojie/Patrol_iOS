//
//  TaskSBViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/6.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SwiftyJSON

class TaskSBViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskType: UIButton!
    @IBOutlet weak var taskTypeTableView: UITableView!
    @IBOutlet weak var taskLine: UIButton!
    @IBOutlet weak var taskLineTableView: UITableView!
    @IBOutlet weak var taskExplain: UITextView!
    @IBOutlet weak var taskStartLabel: UILabel!
    @IBOutlet weak var taskStart: UIButton!
    @IBOutlet weak var taskStop: UIButton!
    
    fileprivate let navigationTitle_Default = "任务"
    fileprivate let navigationTitle_Loading = "加载中"
    let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let titleLabel = UILabel()
    let defaultTaskModel = TaskModel(isStarted: false, tid: -1, uid: -1, tName: "", tType: "", tLineCode: "", startTime: Date(), remark: "")
    
    var taskModel : TaskModel = TaskModel(isStarted: false, tid: -1, uid: -1, tName: "", tType: "", tLineCode: "", startTime: Date(), remark: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTypeTableView.dataSource = self
        self.taskTypeTableView.delegate = self
        self.taskLineTableView.dataSource = self
        self.taskLineTableView.delegate = self
        
        self.taskExplain.delegate = self
        setupUI()

        checkTaskIsStarted()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if((loginInfo?.config?.taskType.count)! > 0){
            if(taskType.title(for: .normal) == nil && !self.taskModel.isStarted){
                let code = loginInfo?.config?.taskType[0].code
                setSelection(taskTypeCode: code!)
                taskTypeTableView.isHidden = true
            }
        }
        if (loginInfo?.config?.taskLine.count)! > 0 {
            if taskLine.title(for: .normal) == nil && !self.taskModel.isStarted {
                let code = loginInfo?.config?.taskLine[0].code
                setSelection(taskLineCode: code!)
                taskLineTableView.isHidden = true
            }
        }
    }

    @IBAction func taskTypeBtnTouchUpInSide(_ sender: Any) {
        switchTaskTypeTable()
    }
    
    @IBAction func taskLineTouchUpInSide(_ sender: Any) {
        switchTaskLineTable()
    }

    @IBAction func startTaskTouchUpInSide(_ sender: Any) {
        startBtnTouchUpInSide()
    }
    
    @IBAction func stopTaskTouchUpInSide(_ sender: Any) {
        endBtnTouchUpInSide()
    }
    
    func backButtonAction(){
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }

}

extension TaskSBViewController{
    
    fileprivate func alertAndLog(msg: String, showTime: TimeInterval, log: String){
        AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: showTime)
        printLog(message: log)
        
        self.view.isUserInteractionEnabled = true
    }
    
    
    fileprivate func checkTaskIsStarted(){
        let request = TaskSBViewController.getCurrentTaskRequest(userId: (loginInfo?.userId)!)
        currentTaskAsyncConnect(urlRequest: request)
    }

    static func getCurrentTaskRequest(userId: Int) -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_CurrentTask)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        
        urlRequest.httpBody = ("id=" + String(userId)).data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        return urlRequest
    }

    private func currentTaskAsyncConnect(urlRequest : URLRequest){
        self.changeTitle(isLoad: true)
        self.view.isUserInteractionEnabled = false
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 0.5, log: String(statusCode) + msg_HttpError + url_CurrentTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(error != nil){
                    self.alertAndLog(msg: msg_ConnectTimeout, showTime: 0.5, log: String(describing: error) + log_Timeout + url_CurrentTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(data?.isEmpty)!{
                    self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_ServerNoResponse + url_CurrentTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let ndata = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                        }
                        self.changeTitle(isLoad: false)
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                    if ndata != JSON.null {
                        
                        let taskId = ndata["id"].int
                        let uId = ndata["uid"].int
                        let tName = ndata["taskname"].string
                        let tType = ndata["tasktype"].string
                        let tTaskLine = ndata["linecode"].string
                        let sstartTime = ndata["starttime"].string
                        let remark = ndata["remark"].string
                        
                        let ssstartTime = sstartTime?.replacingOccurrences(of: "T", with: " ")
                        let formatter = getDateFormatter(dateFormatter: "yyyy-MM-dd HH:mm:ss")
                        let startTime = formatter.date(from: ssstartTime!)
                        
                        self.taskModel = TaskModel(isStarted: true, tid: taskId!, uid: uId!, tName: tName!, tType: tType!, tLineCode: tTaskLine, startTime: startTime!, remark: remark!)
                        self.setTaskView(model: self.taskModel)
                    }else{
                        self.taskModel = TaskModel(isStarted: false, tid: nil, uid: nil, tName: nil, tType: nil, tLineCode: nil, startTime: nil, remark: nil)
                        self.setTaskView(model: self.taskModel)
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_ServerNoResponse + url_Login)
                self.changeTitle(isLoad: false)
                self.view.isUserInteractionEnabled = true
                return
            }
            self.changeTitle(isLoad: false)
            self.view.isUserInteractionEnabled = true
        })
    }

    fileprivate func createTask(){
        let request = getCreateTaskRequest()
        if let re = request {
            createTaskAsyncConnect(urlRequest: re)
        } else {
            AlertWithNoButton(view: self, title: msg_RequestError, message: nil, preferredStyle: .alert, showTime: 1)
        }
    }
    
    private func getCreateTaskRequest() -> URLRequest? {
        var urlRequest = URLRequest(url: URL(string: url_CreateTask)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let df = getDateFormatter(dateFormatter: kDateTimeFormate)
        let sDate = df.string(from: self.taskModel.startTime!)
        let xx = self.taskModel.remark ?? ""
        
        var jsonDic = Dictionary<String,Any>()
        jsonDic["uid"] = loginInfo?.userId
        jsonDic["taskname"] = self.taskModel.taskName ?? ""
        jsonDic["tasktype"] = self.taskModel.taskTypeCode ?? ""
        jsonDic["linecode"] = self.taskModel.taskLineCode ?? ""
        jsonDic["starttime"] = sDate
        jsonDic["remark"] = xx

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
            urlRequest.httpShouldHandleCookies = true
        }catch {
            printLog(message: "Create event. json data wrong\(error)")
            return nil
        }
        
        return urlRequest
    }
    
    private func createTaskAsyncConnect(urlRequest : URLRequest){
        self.changeTitle(isLoad: true)
        self.view.isUserInteractionEnabled = false
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 1, log: String(statusCode) + msg_HttpError + url_CreateTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(error != nil){
                    self.alertAndLog(msg: msg_ConnectTimeout, showTime: 1, log: String(describing: error) + log_Timeout + url_CreateTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(data?.isEmpty)!{
                    self.alertAndLog(msg: msg_ServerNoResponse, showTime: 1, log: log_ServerNoResponse + url_CreateTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let ndata = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                        }
                        self.changeTitle(isLoad: false)
                        self.view.isUserInteractionEnabled = true
                        return
                    }
                    if ndata != JSON.null {
                        let taskId = ndata["id"].int
                        self.taskModel.taskid = taskId
                        self.taskModel.isStarted = true
                        self.setTaskView(model: self.taskModel)
                    }else{
                        //can not be here
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self.alertAndLog(msg: msg_ServerNoResponse, showTime: 0.5, log: log_ServerNoResponse + url_Login)
                self.changeTitle(isLoad: false)
                self.view.isUserInteractionEnabled = true
                return
            }
            self.changeTitle(isLoad: false)
            self.view.isUserInteractionEnabled = true
        })
    }

    fileprivate func endBtnTouchUpInSide(){
        let request = getEndTaskRequest()
        endTaskAsyncConnect(urlRequest: request)
    }
    
    private func getEndTaskRequest() -> URLRequest{
        var urlRequest = URLRequest(url: URL(string: url_EndTask)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        
        let df = getDateFormatter(dateFormatter: kDateTimeFormate)
        let endDate = Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        let sendDate = df.string(from: endDate)
        
        let uid : Int = (loginInfo?.userId!)!
        let tid : Int = (self.taskModel.taskid)!
        
        let body = "uid=\(uid)&tid=\(tid)&endtime=\(sendDate)&remark=\(self.taskModel.remark ?? "")"
        urlRequest.httpBody = body.data(using: String.Encoding.utf8)
        urlRequest.httpShouldHandleCookies = true
        return urlRequest
    }
    
    private func endTaskAsyncConnect(urlRequest : URLRequest){
        self.changeTitle(isLoad: true)
        self.view.isUserInteractionEnabled = false
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    self.alertAndLog(msg: String(statusCode) + msg_HttpError, showTime: 1, log: String(statusCode) + msg_HttpError + url_EndTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(error != nil){
                    self.alertAndLog(msg: msg_ConnectTimeout, showTime: 1, log: String(describing: error) + log_Timeout + url_EndTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                if(data?.isEmpty)!{
                    self.alertAndLog(msg: msg_ServerNoResponse, showTime: 1, log: log_ServerNoResponse + url_EndTask)
                    self.changeTitle(isLoad: false)
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithNoButton(view: self, title: msg, message: nil, preferredStyle: .alert, showTime: 1)
                        }
                        self.changeTitle(isLoad: false)
                        self.view.isUserInteractionEnabled = true
                        return
                    }else{
                        self.taskModel = self.defaultTaskModel
                        self.setTaskView(model: self.taskModel)
                    }
                }else{
                    // running there must be webapi error
                }
            }else{
                self.alertAndLog(msg: msg_ServerNoResponse, showTime: 1, log: log_ServerNoResponse + url_Login)
                self.changeTitle(isLoad: false)
                self.view.isUserInteractionEnabled = true
                return
            }
            self.changeTitle(isLoad: false)
            self.view.isUserInteractionEnabled = true
        })
    }
    
}

extension TaskSBViewController{

    fileprivate func setupUI(){
        setupScrollView()
        setupBackButton()
        setupTitle()
        self.taskStop.isHidden = true
        taskStart.sendSubview(toBack: taskStartLabel)
        self.view.bringSubview(toFront: taskStart)
        
        setupSuperViewJT()
    }
    
    private func setupSuperViewJT() {
        let jtPop = self.navigationController as? JTViewControllerInteractiveTransitionDelegate
        if var jtpop = jtPop {
            jtpop.jtViewControllerInteractiveTransition = JTViewControllerInteractiveTransition(fromVc: self) {
                self.backButtonAction()
            }
        }
    }
    
    private func setupScrollView(){
        scrollView.frame = self.view.frame
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        //scrollView.pagingEnabled = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        //scrollView.delegate = self
        scrollView.scrollsToTop = true
        scrollView.keyboardDismissMode = .onDrag
    }
    
    private func setupBackButton(){
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    private func setupTitle(){
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        self.navigationItem.titleView = view
        
        let wid : CGFloat = 65.0//3 chn charactor
        let hei : CGFloat = 44.0
        let x : CGFloat = 32.5
        let y : CGFloat = 0
        titleLabel.frame = CGRect(x: x, y: y, width: wid, height: hei)
        titleLabel.text = navigationTitle_Default
        titleLabel.textAlignment = .center
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(titleLabel)
        
        titleActivity.center.x = x - 20
        titleActivity.center.y = hei/2
        view.addSubview(titleActivity)
    }
    
    fileprivate func changeTitle(isLoad : Bool){
        if(isLoad){
            self.view.isUserInteractionEnabled = false
            titleActivity.startAnimating()
            titleLabel.text = navigationTitle_Loading
        }else{
            self.view.isUserInteractionEnabled = true
            titleActivity.stopAnimating()
            titleLabel.text = navigationTitle_Default
        }
    }
    
    fileprivate func setTaskView(model : TaskModel){
        
        if(model.isStarted){
            taskName.text = model.taskName
            taskName.isEnabled = false
            
            setSelection(taskTypeCode: (model.taskTypeCode)!)
            taskType.isEnabled = false
            taskTypeTableView.isHidden = true
            
            setSelection(taskLineCode: (model.taskLineCode)!)
            taskLine.isEnabled = false
            taskLineTableView.isHidden = true
            
            taskExplain.text = model.remark
            let dTime = getDateFormatter(dateFormatter: kDateTimeFormate).string(from: (model.startTime)!)
            taskStartLabel.text = dTime
            
            taskStart.isHidden = true
            taskStop.isHidden = false
            
            loginInfo?.taskId = model.taskid
            
            MLocationManager.instance.startUpdatingLocation()
        }else{
            taskName.text = model.taskName
            taskName.isEnabled = true
            
            if(model.taskTypeCode != nil){
                setSelection(taskTypeCode: (model.taskTypeCode!))
            }
            taskType.isEnabled = true
            taskTypeTableView.isHidden = true
            
            if model.taskLineCode != nil {
                setSelection(taskLineCode: model.taskLineCode!)
            }
            taskLine.isEnabled = true
            taskLineTableView.isHidden = true
            
            taskExplain.text = model.remark
            if(model.startTime != nil){
                taskStartLabel.text = (getDateFormatter(dateFormatter: kDateTimeFormate)).string(from: (model.startTime!))
            }
            
            taskStart.isHidden = false
            taskStop.isHidden = true
            
            loginInfo?.taskId = nil
            
            MLocationManager.instance.stopUpdatingLocation()
        }
    }
    
    fileprivate func startBtnTouchUpInSide(){
        self.view.isUserInteractionEnabled = false
        self.taskModel.taskName = taskName.text
        self.taskModel.remark = taskExplain.text
        
        let zone = TimeZone.current
        self.taskModel.startTime = Date()
        self.taskModel.startTime?.addTimeInterval(TimeInterval(Double(zone.secondsFromGMT())))
        if(self.taskModel.remark == nil){
            self.taskModel.remark = ""
        }
        if(!checkStartInput()){
            self.view.isUserInteractionEnabled = true
            return
        }
        
        createTask()
    }
    
    private func checkStartInput() -> Bool {
        if(self.taskModel.taskName == nil || (self.taskModel.taskName?.isEmpty)!){
            AlertWithNoButton(view: self, title: msg_PleaseEnterTaskName, message: nil, preferredStyle: .alert, showTime: 1)
            self.taskName.becomeFirstResponder()
            return false
        }
        if(self.taskModel.taskTypeCode == nil || (self.taskModel.taskTypeCode?.isEmpty)!){
            AlertWithNoButton(view: self, title: msg_PleaseSelectTaskType, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        if self.taskModel.taskLineCode == nil || (self.taskModel.taskLineCode?.isEmpty)! {
            AlertWithNoButton(view: self, title: msg_PleastSelectTaskLine, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        return true
    }
}

extension TaskSBViewController: UITableViewDataSource , UITableViewDelegate{
    
    func switchTaskTypeTable(){
        if(self.taskTypeTableView.isHidden){
            self.view.bringSubview(toFront: taskTypeTableView)
            UIView.animate(withDuration: 0.5, animations: {
                self.taskTypeTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.taskTypeTableView?.isHidden = true
            })
        }
    }
    
    func switchTaskLineTable(){
        if(self.taskLineTableView.isHidden){
            self.view.bringSubview(toFront: taskLineTableView)
            UIView.animate(withDuration: 0.5, animations: {
                self.taskLineTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.taskLineTableView?.isHidden = true
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return (loginInfo?.config?.taskType.count)!
        } else if tableView.tag == 1 {
            return (loginInfo?.config?.taskLine.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil  {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
        }
        
        cell?.backgroundColor = UIColor(red: 113, green: 122, blue: 132)
        let sView = UIView()
        sView.backgroundColor = UIColor(red: 58, green: 68, blue: 87)
        cell?.selectedBackgroundView = sView
        
        if tableView.tag == 0 {
            let item = loginInfo?.config?.taskType[indexPath.row]
            cell?.textLabel?.text = item?.alias
        } else if tableView.tag == 1 {
            let item = loginInfo?.config?.taskLine[indexPath.row]
            cell?.textLabel?.text = item?.alias
        }
        
        cell?.textLabel?.textAlignment = .center
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 0 {
            let item = loginInfo?.config?.taskType[indexPath.row]
            self.taskModel.taskTypeCode = item?.code
            self.taskType.setTitle((item?.alias)!, for: .normal)
            switchTaskTypeTable()
        } else if tableView.tag == 1 {
            let item = loginInfo?.config?.taskLine[indexPath.row]
            self.taskModel.taskLineCode = item?.code
            self.taskLine.setTitle((item?.alias)!, for: .normal)
            switchTaskLineTable()
        }
    }
    
    func setSelection(taskTypeCode : String){
        let index = loginInfo?.config?.taskType.index(where: { (iTType) -> Bool in
            return iTType.code == taskTypeCode
        })
        if let iindex = index{
            tableView(self.taskTypeTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
    
    func setSelection(taskLineCode : String){
        let index = loginInfo?.config?.taskLine.index(where: { (iTType) -> Bool in
            return iTType.code == taskLineCode
        })
        if let iindex = index{
            tableView(self.taskLineTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
    
}

extension TaskSBViewController: UITextViewDelegate  {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(!self.taskTypeTableView.isHidden){
            switchTaskTypeTable()
        }
        if !self.taskLineTableView.isHidden {
            switchTaskLineTable()
        }
    }
    
}





