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
    
    fileprivate let navigationTitle_Default = "事件详情"
    fileprivate let navigationTitle_Loading = "加载中"
    fileprivate let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate let titleLabel = UILabel()
    
    fileprivate let pageSize = 10
    
    fileprivate var total = 0
    fileprivate var pageNum = 1
    //fileprivate var events: [JSON_Event] = [JSON_Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }


}

extension EventDetailViewController {
    
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
        self.tableView.backgroundColor = .yellow
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        navi?.popViewController(animated: true)
    }
    
    private func setupRightBarButton() {
        let img = UIImage(named: "dealEvent")?.withRenderingMode(.alwaysOriginal)
        let rightBtn = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    internal func rightBarButtonClicked() {
        //self.present(EventReportViewController(), animated: true, completion: nil)
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

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registCell() {
        self.tableView.register(THJTableViewCell.self, forCellReuseIdentifier: "THJCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "THJCell") as! THJTableViewCell
        var s = "123456789012345"
        for _ in 0...indexPath.row {
            s += s
        }
        cell.setData(str1: s, str2: "")
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(EventTableViewCell.cellHeight)
//    }
    
    
}
