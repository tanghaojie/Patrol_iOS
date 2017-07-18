//
//  EventReportSBViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/17.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
//main
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
    @IBOutlet weak var commit: UIButton!
    
    fileprivate let navigationTitle_Default = "事件上报"
    fileprivate let navigationTitle_Loading = "加载中"
    fileprivate let defaultAddImageAccessibilityIdentifier = "de_add_image_iden"
    fileprivate let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    fileprivate let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate let titleLabel = UILabel()
    fileprivate let defaultAddImage = UIImage(named: "addImage")
    fileprivate let collectionViewCellHeight = 85
    fileprivate let collectionViewCellWidth = 85
    fileprivate let maxImageCount = 9
    
    //var defaultModel = EventModel(uid: nil, eventId: nil, eventName: nil, eventTypeCode: nil, eventLevelCode: nil, location: nil, address: nil, date: nil, remark: nil,images: nil)
    let eventModel = EventModel(uid: nil, eventId: nil, eventName: nil, eventTypeCode: nil, eventLevelCode: nil, location: nil, address: nil, date: nil, remark: nil,images: nil)
    
    //for save self.eventImage collectionViewCell and for display data   ps. an add image button image is also in the array
    var imageArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventTypeTableView.delegate = self
        self.eventTypeTableView.dataSource = self
        self.eventLevelTableView.delegate = self
        self.eventLevelTableView.dataSource = self
        self.eventImage.delegate = self
        self.eventImage.dataSource = self

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
        commitTouchUpInSide()
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
//func
extension EventReportSBViewController {
    
    fileprivate func commitTouchUpInSide() {
        setLoading(isLoading: true)
        setModel()
        if !checkInput() {
            setLoading(isLoading: false)
            return
        }
        
        
        setLoading(isLoading: false)
    }
    
    private func setModel(){
        eventModel.eventName = eventName.text
        if eventModel.location == nil {
            eventModel.location = MLocationManager.instance.location?.coordinate
        }
        eventModel.address = strLocation.text
        eventModel.date = eventDate.date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        eventModel.remark = eventDetail.text
        let images: NSMutableArray = NSMutableArray()
        if imageArray.count > 1 {
            for item in imageArray {
                let nImage = item as? UIImage
                if let image = nImage {
                    if image.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                        images.add(image)
                    }
                }
            }
        }
        eventModel.images = images.count > 0 ? images : nil
    }
    
    private func checkInput() -> Bool {
        if self.eventModel.eventName == nil || (self.eventModel.eventName?.isEmpty)! {
            AlertWithNoButton(view: self, title: msg_PleaseEnterEventName, message: nil, preferredStyle: .alert, showTime: 1)
            self.eventName.becomeFirstResponder()
            return false
        }
        if self.eventModel.eventTypeCode == nil || (self.eventModel.eventTypeCode?.isEmpty)! {
            AlertWithNoButton(view: self, title: msg_PleaseSelectEventType, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        if self.eventModel.eventLevelCode == nil || (self.eventModel.eventLevelCode?.isEmpty)! {
            AlertWithNoButton(view: self, title: msg_PleaseSelectEventLevel, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        if self.eventModel.location == nil {
            AlertWithNoButton(view: self, title: msg_PleaseSelectEventLocation, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        return true
    }
    
    private func setLoading(isLoading: Bool){
        if isLoading {
            self.view.isUserInteractionEnabled = false
            titleActivity.startAnimating()
            titleLabel.text = navigationTitle_Loading
        } else {
            self.view.isUserInteractionEnabled = true
            titleActivity.stopAnimating()
            titleLabel.text = navigationTitle_Default
        }
    }
    
}
//ui
extension EventReportSBViewController {
    
    fileprivate func setupUI(){
        
        setupBackButton()
        setupScrollView()
        setupTitle()
        setupInitBtnImage()
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        self.eventImage.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        addLongPressListener()
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
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 900)
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
//tableview
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
//collectionview
extension EventReportSBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate func setupInitBtnImage() {
        defaultAddImage?.accessibilityIdentifier = defaultAddImageAccessibilityIdentifier
        imageArray.add(defaultAddImage as Any)
        self.eventImage.reloadData()
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = imageArray.count
        let countPerRow = floor(self.eventImage.frame.width / CGFloat(collectionViewCellWidth))
        let rowCount = Int(ceil(CGFloat(count) / countPerRow))
        let height = rowCount * collectionViewCellHeight
        if self.eventImage.frame.height != CGFloat(height) {
            self.eventImage.frame = CGRect(x: self.eventImage.frame.minX, y: self.eventImage.frame.minY, width: self.eventImage.frame.width, height: CGFloat(height))
            self.commit.frame = CGRect(x: self.commit.frame.minX, y: self.eventImage.frame.maxY + 10, width: self.commit.frame.width, height: self.commit.frame.height)
        }
        return count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath)
        let image = imageArray[indexPath.row] as? UIImage

        let imageView = UIImageView(frame: CGRect(x: 1, y: 1, width: 80, height: 80))
        imageView.backgroundColor = self.eventImage.backgroundColor
        imageView.image = image
        imageView.center = cell.contentView.center
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nImage = imageArray[indexPath.row] as? UIImage
        if let image = nImage {
            if image.accessibilityIdentifier == defaultAddImageAccessibilityIdentifier {
                addImageAction()
            }
        }
    }
    
    fileprivate func addLongPressListener(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.collectionViewLongPress))
        longPress.minimumPressDuration = 1
        self.eventImage.addGestureRecognizer(longPress)
    }
    
    internal func collectionViewLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let actionController = UIAlertController(title: "", message: "警告", preferredStyle: .actionSheet)
            let location = longPressGestureRecognizer.location(in: self.eventImage)
            let nIndexPath = self.eventImage.indexPathForItem(at: location)
            if nIndexPath != nil{
                let image = self.imageArray[nIndexPath!.row] as? UIImage
                if image != nil {
                    if image?.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                        let actionDel = UIAlertAction(title: "删除", style: .default){ (_) -> Void in
                            self.imageArray.remove(image as Any)
                            self.eventImage.reloadData()
                        }
                        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        actionController.addAction(actionDel)
                        actionController.addAction(actionCancel)
                        self.navigationController?.present(actionController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}
//imagePickerController
extension EventReportSBViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func addImageAction(){
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let actionController = UIAlertController(title: "提示", message: "拍照或从相册选择", preferredStyle: .actionSheet)
        let actionAlbum = UIAlertAction(title: "从相册选择", style: .default){ (action) -> Void in
            picker.sourceType = .savedPhotosAlbum
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "拍照", style: .default){ (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.navigationController?.present(picker, animated: true, completion: nil)
            } else {
                AlertWithNoButton(view: self, title: "", message: "不支持拍照", preferredStyle: .alert, showTime: 1)
            }
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionController.addAction(actionAlbum)
        actionController.addAction(actionCamera)
        actionController.addAction(actionCancel)
        
        self.navigationController?.present(actionController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageArray.removeLastObject()
        imageArray.add(image)
        if imageArray.count < maxImageCount {
            imageArray.add(defaultAddImage as Any)
        }
        
        picker.dismiss(animated: true, completion: nil)
        self.eventImage.reloadData()
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
