//
//  EventDetailViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class EventDetailViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var tableViewHeader: MJRefreshNormalHeader!
    fileprivate var tableViewFooter: MJRefreshAutoGifFooter!
    fileprivate var leftBtn: UIBarButtonItem!
    fileprivate var rightBtn: UIBarButtonItem!
    
    fileprivate var subNavigationBar: UIView!
    fileprivate var titleLabel1: UILabel!
    fileprivate var titleLabel2: UILabel!
    fileprivate var titleImage: UIImageView!
    
    fileprivate let navigationTitle_Default = "事件详情"
    fileprivate let navigationTitle_Loading = "加载中"
    fileprivate let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate let titleLabel = UILabel()
    fileprivate let event: JSON_Event?
    
    static let navigationItemIncrease: CGFloat = 30.0
    fileprivate var data: [Any] = [Any]()

    init(_ json_Event: JSON_Event?) {
        if let event = json_Event {
            self.event = event
            data.append(event)
        } else {
            self.event = nil
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNavigationbar(isBig: true)
    }

}

extension EventDetailViewController {
    
    fileprivate func setupUI() {
        
        setupBackButton()
        setupRightBarButton()
        setupTitle()
        setupNavigationbar(isBig: true)
        
        setupTableView()
        setupRefreshHeader()
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
        self.tableView.backgroundColor = .yellow
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.view = tableView
        self.tableView.contentInset = UIEdgeInsets(top: EventDetailViewController.navigationItemIncrease, left: 0, bottom: 0, right: 0)
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
        getData(eventId: (self.event?.id)!)
    }

    fileprivate func endRefreshing() {
        self.tableView.mj_header.endRefreshing()
    }
    
    private func setupBackButton() {
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        self.leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = self.leftBtn;
    }
    
    internal func backButtonAction() {
        setupNavigationbar(isBig: false)
        
        let navi = self.navigationController
        navi?.popViewController(animated: true)
    }
    
    private func setupRightBarButton() {
        if event?.statecode == "0001010500000002" {
            let img = UIImage(named: "dealEvent")?.withRenderingMode(.alwaysOriginal)
            self.rightBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightBarButtonClicked))
            self.navigationItem.rightBarButtonItem = self.rightBtn
        }
    }
    
    internal func rightBarButtonClicked() {
        let sb = UIStoryboard(name: "EventDealSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EventDealSBViewController") as! EventDealSBViewController
        vc.setEvent(self.event)
        setupNavigationbar(isBig: false)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    fileprivate func setupNavigationbar(isBig: Bool) {
        let bar = self.navigationController?.navigationBar
        let baseFrame = bar?.frame
        if isBig {
            if self.subNavigationBar == nil {
                self.subNavigationBar = UIView(frame: CGRect(x: 0, y: (baseFrame?.height)!, width: kScreenWidth, height: EventDetailViewController.navigationItemIncrease))
                self.subNavigationBar.backgroundColor = .red
                
                let w = kScreenWidth / 3
                self.titleLabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: EventDetailViewController.navigationItemIncrease))
                self.titleLabel1.textAlignment = .center
                self.titleLabel1.font = UIFont.systemFont(ofSize: 16)
                self.titleLabel1.text = self.event?.typecode_alias
                self.subNavigationBar.addSubview(self.titleLabel1)
                
                self.titleLabel2 = UILabel(frame: CGRect(x: w, y: 0, width: w , height: EventDetailViewController.navigationItemIncrease))
                self.titleLabel2.textAlignment = .center
                self.titleLabel2.font = UIFont.systemFont(ofSize: 16)
                self.titleLabel2.text = self.event?.levelcode_alias
                self.subNavigationBar.addSubview(self.titleLabel2)
                
                self.titleImage = UIImageView(frame: CGRect(x: w * 2, y: 0, width: w, height: EventDetailViewController.navigationItemIncrease))
                self.titleImage.image = UIImage(named: "point")
                self.titleImage.contentMode = .center
                self.subNavigationBar.addSubview(self.titleImage)
                
                bar?.addSubview(subNavigationBar)
            } else {
                subNavigationBar.isHidden = false
            }
        } else {
            subNavigationBar.isHidden = true
        }
    }

}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registCell() {
        self.tableView.register(THJTableViewCell.self, forCellReuseIdentifier: "THJCell")
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "THJCell") as! THJTableViewCell
        let any = data[indexPath.row]
        if let event = any as? JSON_Event {
            cell.setData(event: event)
        } else if let process = any as? JSON_Process {
            cell.setData(process: process)
        }
        return cell
    }
    
}

extension EventDetailViewController {
    
    fileprivate func getData(eventId: Int) {
        let request = getQueryProcessListRequest(eventId: eventId)
        if request == nil {
            AlertWithNoButton(view: self, title: msg_SomethingWrongTryAgain, message: "", preferredStyle: .alert, showTime: 1)
            self.endRefreshing()
            return
        }
        queryProcessList(request: request!, complete: {(data: JSON) in
            let processList = JSON_EventProcess(data)
            if(processList.status != 0){
                if let msg = processList.msg {
                    AlertWithUIAlertAction(view: self, title: msg, message: "", preferredStyle: UIAlertControllerStyle.alert, uiAlertAction: UIAlertAction(title: msg_OK, style: .default, handler: nil))
                }
                self.endRefreshing()
                return
            }
        
            self.data.removeAll()
            if let e = self.event {
                self.data.append(e)
            }
            
            for item in processList.datas {
                self.data.append(item)
            }

            self.tableView.reloadData()
            self.endRefreshing()
        })
    }
    
    private func queryProcessList(request: URLRequest, complete: ((JSON) -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                AlertWithNoButton(view: self, title: msg_Error, message: "\(msg_RequestError) \(error?.localizedDescription ?? "")", preferredStyle: .alert, showTime: 1)
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
                
                print("Query process list success \(Date().addingTimeInterval(kTimeInteval))")
                let json = JSON(data : data!)
                if let com = complete {
                    com(json)
                }
            } else {
                self.endRefreshing()
            }
        })
    }
    
    private func getQueryProcessListRequest(eventId: Int) -> URLRequest? {
        var urlRequest = URLRequest(url: URL(string: url_QueryProcessList)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        
        let jsonDic = getQueryProcessListRequestData(eventId: eventId)
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
    
    private func getQueryProcessListRequestData(eventId: Int) -> Dictionary<String,Any> {
        var jsonDic = Dictionary<String,Any>()
        jsonDic["id"] = eventId

        return jsonDic
    }
    
}
