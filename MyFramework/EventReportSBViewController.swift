//
//  EventReportSBViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/17.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SwiftyJSON
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
    @IBOutlet weak var eventImageHeight: NSLayoutConstraint!
    @IBOutlet weak var commit: UIButton!
    
    fileprivate let navigationTitle_Default = "事件上报"
    fileprivate let navigationTitle_Loading = "请稍后"
    fileprivate let defaultAddImageAccessibilityIdentifier = "de_add_image_iden"
    fileprivate let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    fileprivate let titleActivity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    fileprivate let titleLabel = UILabel()
    fileprivate let defaultAddImage = UIImage(named: "addImage")
    fileprivate let collectionViewCellHeight = 85
    fileprivate let collectionViewCellWidth = 85
    fileprivate let maxImageCount = 9
    fileprivate let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    fileprivate let imagePathName = "EventImages"
    
    let eventModel = EventModel(uid: nil, eventId: nil, eventName: nil, eventTypeCode: nil, eventLevelCode: nil, location: nil, address: nil, date: nil, remark: nil,images: nil)
    
    //for save self.eventImage collectionViewCell and for display data   ps. an add image button image is also in the array
    var imageArray: NSMutableArray = NSMutableArray()
    
    public var reportSuccessFunc: (()->())?
    
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
        self.eventDate.maximumDate = Date()
        eventDate.date = Date()
    }
    
    @IBAction func currentLocationTouchUpInSide(_ sender: Any) {
        let navi = self.navigationController
        navi?.present(JTSelectLocationViewController(){ (latitude,longitude) in
            let coor = CLLocationCoordinate2D(latitude: CLLocationDegrees().advanced(by: latitude), longitude: CLLocationDegrees().advanced(by: longitude))
            self.setupLocation(location: coor)
        }, animated: true, completion: nil)
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
        let nRequest = getCreateEventRequest()
        if let request = nRequest {
            createEvent(request: request, complete: createEventComplete)
        }else {
            AlertWithNoButton(view: self, title: msg_SomethingWrongTryAgain, message: "", preferredStyle: .alert, showTime: 1)
            setLoading(isLoading: false)
        }
    }
    
    private func createEventComplete() {
        backButtonAction()
        if let successFunc = self.reportSuccessFunc {
            successFunc()
        }
    }
    
    private func createEvent(request: URLRequest, complete: (() -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { [weak self] (response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                if let xself = self {
                    AlertWithNoButton(view: xself, title: msg_Error, message: msg_RequestError, preferredStyle: .alert, showTime: 1)
                }
                self?.setLoading(isLoading: false)
                return
            }
            if (data?.isEmpty)! {
                if let xself = self {
                    AlertWithNoButton(view: xself, title: msg_Error, message: msg_ServerNoResponse, preferredStyle: .alert, showTime: 1)
                }
                self?.setLoading(isLoading: false)
                return
            }
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    if let xself = self {
                        AlertWithNoButton(view: xself, title: msg_Error, message: msg_HttpError, preferredStyle: .alert, showTime: 1)
                    }
                    self?.setLoading(isLoading: false)
                    return
                }
                let json = (try? JSON(data : data!))!
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let data = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            if let xself = self {
                                AlertWithUIAlertAction(view: xself, title: msg, message: "", preferredStyle: UIAlertController.Style.alert, uiAlertAction: UIAlertAction(title: msg_OK, style: .default, handler: nil))
                            }
                        }
                        self?.setLoading(isLoading: false)
                        return
                    }
                    if data != JSON.null  {
                        let eventId = data["id"].int
                        if let images = self?.eventModel.images {
                            if images.count > 0 {
                                let date = getDateFormatter(dateFormatter: "yyyy-MM-dd+HH:mm:ss").string(from: Date().addingTimeInterval(kTimeInteval))
                                Image.instance.uploadImages(images: images, prid: String(eventId!), typenum: "1", actualtime: date, compress: Image.instance.wechatCompressImage(originalImg:), isCache: true, imagesUploadComplete: nil)
                            }
                        }
                        if complete != nil {
                            complete!()
                        }
                    }else {
                        //application will not running here in normal situation
                    }
                }else{
                    // running there must be webapi error
                }
            }
            self?.setLoading(isLoading: false)
        })
    }

    private func getCreateEventRequest() -> URLRequest? {
        var urlRequest = URLRequest(url: URL(string: url_CreateEvent)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
   
        let jsonDic = getRequestData()
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
    
    private func getRequestData() -> Dictionary<String,Any> {
        var jsonDic = Dictionary<String,Any>()
        jsonDic["uid"] = loginInfo?.userId
        jsonDic["eventname"] = self.eventModel.eventName
        jsonDic["typecode"] = self.eventModel.eventTypeCode
        jsonDic["levelcode"] = self.eventModel.eventLevelCode
        if let location = self.eventModel.location {
            jsonDic["location"] = getLocationDictionary(location: location)
        }
        jsonDic["address"] = self.eventModel.address
        jsonDic["statecode"] = nil
        if let d = self.eventModel.date {
            jsonDic["actualtime"] = getDateFormatter(dateFormatter: kDateTimeFormate).string(from: d)
        }
        jsonDic["remark"] = self.eventModel.remark
        
        return jsonDic
    }
    
    private func getLocationDictionary(location: CLLocationCoordinate2D) -> Dictionary<String,Any> {
        var locationDic = Dictionary<String,Any>()
        locationDic["x"] = location.longitude
        locationDic["y"] = location.latitude
        return locationDic
    }
    
    private func setModel(){
        eventModel.eventName = eventName.text
        if eventModel.location == nil {

            eventModel.location = JTLocationManager.instance.location?.coordinate
        }
        eventModel.address = strLocation.text
        eventModel.date = eventDate.date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        eventModel.remark = eventDetail.text
        var images = [UIImage]()
        if imageArray.count > 1 {
            for item in imageArray {
                let nImage = item as? UIImage
                if let image = nImage {
                    if image.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                        images.append(image)
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
        let min: Double = 0
        if (self.eventModel.location?.latitude)! <= min || (self.eventModel.location?.longitude)! <= min {
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
    
    private func getImagePath() -> String {
        return "\(cachePath ?? "")/\(imagePathName)"
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
        setupDatePicker()
    }
    
    fileprivate func setupLocation(location: CLLocationCoordinate2D?){
        if let lo = location {
            currentLocation.setTitle("已选择位置（点击选择位置）", for: .normal)
            self.eventModel.location = lo
        } else {
            currentLocation.setTitle("当前位置（点击选择位置）", for: .normal)
            self.eventModel.location = nil
        }
    }
    
    private func setupDatePicker() {
        self.eventDate.maximumDate = Date()
    }
    
    private func setupCollectionView(){
        self.eventImage.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        addLongPressListener()
    }
    
    private func setupScrollView(){
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.scrollsToTop = true
    }
    
    private func setupBackButton(){
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    @objc func backButtonAction(){
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }
    
    private func setupTitle(){
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        self.navigationItem.titleView = view
        
        let wid : CGFloat = 85.0//4 chn charactor
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
    
}
//tableview
extension EventReportSBViewController: UITableViewDataSource , UITableViewDelegate {
    
    fileprivate func switchEventTypeTableView(isHidden: Bool? = nil){
        if isHidden != nil {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventTypeTableView?.isHidden = isHidden!
            })
            return
        }
        if(self.eventTypeTableView.isHidden){
            self.view.bringSubviewToFront(eventTypeTableView)
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventTypeTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventTypeTableView?.isHidden = true
            })
        }
    }
    
    fileprivate func switchEventLevelTableView(isHidden: Bool? = nil){
        if(isHidden != nil){
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventLevelTableView?.isHidden = isHidden!
            })
            return
        }
        if(self.eventLevelTableView.isHidden){
            self.view.bringSubviewToFront(eventLevelTableView)
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventLevelTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.eventLevelTableView?.isHidden = true
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
            let item = loginInfo?.config?.eventType[indexPath.row]
            cell?.textLabel?.text = item?.alias
            cell?.textLabel?.textAlignment = .center
            
            cell?.backgroundColor = UIColor(red: 113, green: 122, blue: 132)
            let sView = UIView()
            sView.backgroundColor = UIColor(red: 58, green: 68, blue: 87)
            cell?.selectedBackgroundView = sView
            
            return cell!
        }else if(tableView.tag == 1){
            var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            if cell == nil  {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
            }
            let item = loginInfo?.config?.eventLevel[indexPath.row]
            cell?.textLabel?.text = item?.alias
            cell?.textLabel?.textAlignment = .center
            
            cell?.backgroundColor = UIColor(red: 113, green: 122, blue: 132)
            let sView = UIView()
            sView.backgroundColor = UIColor(red: 58, green: 68, blue: 87)
            cell?.selectedBackgroundView = sView
            
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
        let index = loginInfo?.config?.eventType.firstIndex(where: { (iTType) -> Bool in
            return iTType.code == eventTypeCode
        })
        if let iindex = index{
            tableView(self.eventTypeTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
    
    fileprivate func setEventLevelSelection(eventLevelCode : String){
        let index = loginInfo?.config?.eventLevel.firstIndex(where: { (iTType) -> Bool in
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
            self.eventImageHeight.constant = CGFloat(height)
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
            } else {
                var imgs = [UIImage]()
                for item in self.imageArray {
                    let img = item as? UIImage
                    if let i = img {
                        if i.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                            imgs.append(i)
                        }
                    }
                }
                if imgs.count > 0 {
                    let previewVC = ImagePreviewViewController(images: imgs, index: indexPath.row)
                    self.navigationController?.pushViewController(previewVC, animated: true)
                }
            }
        }
    }
    
    fileprivate func addLongPressListener(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.collectionViewLongPress))
        longPress.minimumPressDuration = 0.8
        self.eventImage.addGestureRecognizer(longPress)
    }
    @objc internal func collectionViewLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let actionController = UIAlertController(title: "", message: "警告", preferredStyle: .actionSheet)
            let location = longPressGestureRecognizer.location(in: self.eventImage)
            let nIndexPath = self.eventImage.indexPathForItem(at: location)
            if nIndexPath != nil{
                let image = self.imageArray[nIndexPath!.row] as? UIImage
                if image != nil {
                    if image?.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                        let actionDel = UIAlertAction(title: "删除", style: .default){ [weak self] (_) -> Void in
                            self?.imageArray.remove(image as Any)
                            if (self?.imageArray.count)! < (self?.maxImageCount)! {
                                if let addImg = self?.imageArray.lastObject as? UIImage {
                                    if addImg.accessibilityIdentifier != self?.defaultAddImageAccessibilityIdentifier {
                                        self?.setupInitBtnImage()
                                    }
                                }
                            }
                            self?.eventImage.reloadData()
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
        let actionCamera = UIAlertAction(title: "拍照", style: .default){ [weak self] (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self?.navigationController?.present(picker, animated: true, completion: nil)
            } else {
                if let xself = self {
                    AlertWithNoButton(view: xself, title: "", message: "不支持拍照", preferredStyle: .alert, showTime: 1)
                }
            }
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        actionController.addAction(actionAlbum)
        actionController.addAction(actionCamera)
        actionController.addAction(actionCancel)
        
        self.navigationController?.present(actionController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
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


