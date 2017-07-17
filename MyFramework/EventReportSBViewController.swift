//
//  EventReportSBViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/17.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventReportSBViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var eventType: UIButton!
    @IBOutlet weak var eventTypeTableView: UITableView!
    
    @IBOutlet weak var eventLevel: UIButton!
    @IBOutlet weak var eventLevelTableView: UITableView!
    
    @IBOutlet weak var currentLocation: UIButton!
    @IBOutlet weak var strLocation: UITextField!
    @IBOutlet weak var currentDate: UIButton!
    @IBOutlet weak var eventDate: UIDatePicker!
    @IBOutlet weak var eventDetail: UITextView!
    @IBOutlet weak var eventImage: UICollectionView!
    
    fileprivate let navigationTitle_Default = "事件上报"
    fileprivate let navigationTitle_Loading = "加载中"
    let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let titleLabel = UILabel()
    
    var defaultModel = EventModel(uid: nil, eventId: nil, eventName: nil, eventTypeCode: nil, eventLevelCode: nil, location: nil, address: nil, date: nil, remark: nil)
    let eventModel = EventModel(uid: nil, eventId: nil, eventName: nil, eventTypeCode: nil, eventLevelCode: nil, location: nil, address: nil, date: nil, remark: nil)
    
    var imageArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTypeTableView.delegate = self
        self.eventTypeTableView.dataSource = self
        self.eventLevelTableView.delegate = self
        self.eventLevelTableView.dataSource = self
        self.eventImage.delegate = self

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if((loginInfo?.config?.eventType.count)! > 0){
            if(eventType.title(for: .normal) == nil){
                let code = loginInfo?.config?.eventType[0].code
                setEventTypeSelection(eventTypeCode: code!)
                switchEventTypeTableView(isHidden: true)
            }
        }
        if((loginInfo?.config?.eventLevel.count)! > 0){
            if(eventLevel.title(for: .normal) == nil){
                let code = loginInfo?.config?.eventLevel[0].code
                setEventLevelSelection(eventLevelCode: code!)
                switchEventTypeTableView(isHidden: true)
            }
        }
        
        
    }
    
    @IBAction func commitTouchUpInSide(_ sender: Any) {
        
    }

    @IBAction func eventTypeTouchUpInSide(_ sender: Any) {
        switchEventTypeTableView()
    }

    @IBAction func eventLevelTouchUpInSide(_ sender: Any) {
        switchEventLevelTableView()
    }
    
    @IBAction func currentDateTouchUpInSide(_ sender: Any) {
        eventDate.date = Date()
    }
    
    
}

extension EventReportSBViewController {
    
    fileprivate func setupUI(){
        setupBackButton()
        setupScrollView()
        setupTitle()
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
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 700)
    }
    
    private func setupBackButton(){
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    func backButtonAction(){
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }
    
    private func setupTitle(){
        
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
    
    
}

extension EventReportSBViewController: UITableViewDataSource , UITableViewDelegate {
    
    fileprivate func switchEventTypeTableView(isHidden: Bool? = nil){
        if(isHidden != nil){
            UIView.animate(withDuration: 0.5, animations: {
                self.eventTypeTableView?.isHidden = isHidden!
            })
            return
        }
        if(self.eventTypeTableView.isHidden){
            self.view.bringSubview(toFront: eventTypeTableView)
            UIView.animate(withDuration: 0.5, animations: {
                self.eventTypeTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.eventTypeTableView?.isHidden = true
            })
        }
    }
    
    fileprivate func switchEventLevelTableView(isHidden: Bool? = nil){
        if(isHidden != nil){
            UIView.animate(withDuration: 0.5, animations: {
                self.eventLevelTableView?.isHidden = isHidden!
            })
            return
        }
        if(self.eventLevelTableView.isHidden){
            self.view.bringSubview(toFront: eventLevelTableView)
            UIView.animate(withDuration: 0.5, animations: {
                self.eventLevelTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.eventLevelTableView?.isHidden = true
            })
        }
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 0){
            return (loginInfo?.config?.eventType.count)!
        }else if(tableView.tag == 1){
            return (loginInfo?.config?.eventLevel.count)!
        }
        return 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView.tag == 0){
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            if cell == nil  {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
            }
            cell?.backgroundColor = UIColor(red: 225, green: 225, blue: 225)
            let item = loginInfo?.config?.eventType[indexPath.row]
            cell?.textLabel?.text = item?.alias
            cell?.textLabel?.textAlignment = .center
            return cell!
        }else if(tableView.tag == 1){
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            if cell == nil  {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
            }
            cell?.backgroundColor = UIColor(red: 225, green: 225, blue: 225)
            let item = loginInfo?.config?.eventLevel[indexPath.row]
            cell?.textLabel?.text = item?.alias
            cell?.textLabel?.textAlignment = .center
            return cell!
        }
        return tableView.dequeueReusableCell(withIdentifier: "cellid")!
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.tag == 0){
            let item = loginInfo?.config?.eventType[indexPath.row]
            selectedEventType(item: item!)
        }else if(tableView.tag == 1){
            let item = loginInfo?.config?.eventLevel[indexPath.row]
            selectedEventType(item: item!)
        }
    }
    
    private func selectedEventType(item: EventType){
        self.eventModel.eventTypeCode = item.code
        self.eventType.setTitle(item.alias, for: .normal)
        switchEventTypeTableView(isHidden: true)
    }
    
    private func selectedEventType(item: EventLevel){
        self.eventModel.eventLevelCode = item.code
        self.eventLevel.setTitle(item.alias, for: .normal)
        switchEventLevelTableView(isHidden: true)
    }
    
    fileprivate func setEventTypeSelection(eventTypeCode : String){
        let index = loginInfo?.config?.eventType.index(where: { (iTType) -> Bool in
            return iTType.code == eventTypeCode
        })
        if let iindex = index{
            tableView(self.eventTypeTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
    
    fileprivate func setEventLevelSelection(eventLevelCode : String){
        let index = loginInfo?.config?.eventLevel.index(where: { (iTType) -> Bool in
            return iTType.code == eventLevelCode
        })
        if let iindex = index{
            tableView(self.eventLevelTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
    
}

extension EventReportSBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellIdentifier", for: indexPath)
        let image = imageArray[indexPath.row] as? UIImage
        
        let imageView = UIImageView(image: image)
        cell.contentView.addSubview(imageView)
        return cell
    }
    
}

