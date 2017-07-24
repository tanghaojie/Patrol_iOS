//
//  EventOverViewViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class EventOverViewViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var tableViewHeader: MJRefreshNormalHeader!
    fileprivate var tableViewFooter: MJRefreshAutoGifFooter!
    
    fileprivate let navigationTitle_Default = "事件"
    fileprivate let navigationTitle_Loading = "加载中"
    fileprivate let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate let titleLabel = UILabel()
    
    fileprivate let pageSize = 10
    
    fileprivate var total = 0
    fileprivate var pageNum = 1
    fileprivate var events: [JSON_Event] = [JSON_Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.mj_header.beginRefreshing()
    }

}

extension EventOverViewViewController {
    
    fileprivate func setupUI() {
        setupBackButton()
        setupRightBarButton()
        setupTitle()
        
        setupTableView()
        setupRefreshHeader()
        setupRefreshFooter()
    }
    
    private func setupTableView() {
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.bounces = true
        self.tableView.alwaysBounceVertical = true
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.scrollsToTop = true
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()
        self.registCell()
        self.tableView.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view = tableView
    }
    
    private func setupRefreshHeader() {
        self.tableViewHeader = MJRefreshNormalHeader()
        self.tableViewHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        self.tableView.mj_header = self.tableViewHeader
        self.tableViewHeader.setTitle("下拉刷新", for: .idle)
        self.tableViewHeader.setTitle("释放刷新", for: .pulling)
        self.tableViewHeader.setTitle("刷新中...", for: .refreshing)
        self.tableViewHeader.lastUpdatedTimeLabel.text = "上次刷新"
        self.tableViewHeader.activityIndicatorViewStyle = .gray
    }
    
    internal func headerRefresh() {
        print("pull refresh")
        
        getData(refresh: true)
    }
    
    private func setupRefreshFooter() {
        self.tableViewFooter = MJRefreshAutoGifFooter()
        self.tableViewFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        self.tableView.mj_footer = self.tableViewFooter
        self.tableViewFooter.setTitle("加载更多", for: .idle)
        self.tableViewFooter.setTitle("释放以加载更多", for: .pulling)
        self.tableViewFooter.setTitle("加载中...", for: .refreshing)
        self.tableViewFooter.setTitle("没有更多数据", for: .noMoreData)
    }
    
    internal func footerRefresh() {
        print("pull load")
        
        getData(refresh: false)
    }
    
    fileprivate func endRefreshing() {
        self.tableView.mj_header.endRefreshing()
        if self.tableView.mj_footer.state != .noMoreData {
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func setupBackButton() {
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    internal func backButtonAction() {
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }
    
    private func setupRightBarButton() {
        let img = UIImage(named: "eventReport")?.withRenderingMode(.alwaysOriginal)
        let rightBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    internal func rightBarButtonClicked() {
        self.present(EventReportViewController(), animated: true, completion: nil)
    }
    
    private func setupTitle() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        self.navigationItem.titleView = view
        
        let wid : CGFloat = 75.0//4 chn charactor
        let hei : CGFloat = 44.0
        let x : CGFloat = 32.5
        let y : CGFloat = 0
        titleLabel.frame = CGRect(x: x, y: y, width: wid, height: hei)
        titleLabel.text = navigationTitle_Default
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleActivity.center.x = x - 20
        titleActivity.center.y = hei / 2
        view.addSubview(titleActivity)
    }
    
    fileprivate func changeTitle(isLoad : Bool) {
        if isLoad {
            self.view.isUserInteractionEnabled = false
            titleActivity.startAnimating()
            titleLabel.text = navigationTitle_Loading
        }else{
            self.view.isUserInteractionEnabled = true
            titleActivity.stopAnimating()
            titleLabel.text = navigationTitle_Default
        }
    }
    
}

extension EventOverViewViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registCell() {
        self.tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "eventTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventTableViewCell") as! EventTableViewCell
        let data = events[indexPath.row]
        cell.setData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(EventTableViewCell.cellHeight)
    }
    
}

extension EventOverViewViewController {
    
    fileprivate func getData(refresh: Bool) {
        let request: URLRequest?
        if refresh {
            request = getQueryRelationEventListRequest(pNum: 1)
        } else {
            request = getQueryRelationEventListRequest()
        }

        if request == nil {
            AlertWithNoButton(view: self, title: msg_SomethingWrongTryAgain, message: "", preferredStyle: .alert, showTime: 1)
            self.endRefreshing()
            return
        }
        queryRelationEventList(request: request!, complete: {(eventList: JSON_EventList) in
            
            if refresh {
                self.total = 0
                self.pageNum = 1
                self.events = [JSON_Event]()
                self.tableView.mj_footer.state = .idle
            }
            
            self.total = eventList.total
            let datas = eventList.datas
            self.events.append(contentsOf: datas)
            self.tableView.reloadData()
            if datas.count > 0 {
                self.pageNum += 1
            }
            let page = ceil(Double(self.total / self.pageSize))
            if Double(self.pageNum) >= page {
                self.tableView.mj_footer.state = .noMoreData
            }
            self.endRefreshing()
        })
    }
    
    private func queryRelationEventList(request: URLRequest, complete: ((JSON_EventList) -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                AlertWithNoButton(view: self, title: msg_Error, message: msg_RequestError, preferredStyle: .alert, showTime: 1)
                self.endRefreshing()
                return
            }
            if (data?.isEmpty)! {
                AlertWithNoButton(view: self, title: msg_Error, message: msg_ServerNoResponse, preferredStyle: .alert, showTime: 1)
                self.endRefreshing()
                return
            }
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    AlertWithNoButton(view: self, title: msg_Error, message: msg_HttpError, preferredStyle: .alert, showTime: 1)
                    self.endRefreshing()
                    return
                }
                
                print("Query relation event list success \(Date().addingTimeInterval(kTimeInteval))")
                let json = JSON(data : data!)
                
                let eventList = JSON_EventList(json: json)
                if(eventList.status != 0){
                    if let msg = eventList.msg {
                        AlertWithUIAlertAction(view: self, title: msg, message: "", preferredStyle: UIAlertControllerStyle.alert, uiAlertAction: UIAlertAction(title: msg_OK, style: .default, handler: nil))
                    }
                    self.endRefreshing()
                    return
                }
                
                if let com = complete {
                    com(eventList)
                }
            } else {
                self.endRefreshing()
            }
        })
    }
    
    private func getQueryRelationEventListRequest(pNum: Int? = nil) -> URLRequest?{
        var urlRequest = URLRequest(url: URL(string: url_QueryEventList)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        
        let jsonDic = getQueryRelationEventListRequestData(pNum: pNum)
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            urlRequest.httpShouldHandleCookies = true
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            return urlRequest
        }catch {
            printLog(message: "Create event. json data wrong\(error)")
            return nil
        }
    }
    
    private func getQueryRelationEventListRequestData(pNum: Int? = nil) -> Dictionary<String,Any> {
        var jsonDic = Dictionary<String,Any>()
        jsonDic["uid"] = loginInfo?.userId
        jsonDic["starttime"] = nil
        jsonDic["endtime"] = nil
        if let pnum = pNum {
            jsonDic["pagenum"] = pnum
        } else {
            jsonDic["pagenum"] = self.pageNum
        }
        jsonDic["pagesize"] = pageSize
        
        return jsonDic
    }
    
}
