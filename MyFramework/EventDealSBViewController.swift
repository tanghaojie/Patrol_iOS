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
class EventDealSBViewController: UIViewController, JTViewControllerInteractiveTransitionDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventLevel: UILabel!
    @IBOutlet weak var dealLocation: UIButton!
    @IBOutlet weak var currentDate: UIButton!
    @IBOutlet weak var dealDate: UIDatePicker!
    @IBOutlet weak var dealDetail: UITextView!
    @IBOutlet weak var dealImage: UICollectionView!
    @IBOutlet weak var dealImageHeight: NSLayoutConstraint!
    @IBOutlet weak var commit: UIButton!
    
    fileprivate let navigationTitle_Default = "事件处理"
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
    fileprivate let imagePathName = "DealImages"
    
    fileprivate var event: JSON_Event?
    
    fileprivate var location: CLLocationCoordinate2D?
    
    var jtViewControllerInteractiveTransition: JTViewControllerInteractiveTransition? = nil
    
    
    public var dealSuccess: (()->())?

    //for save self.eventImage collectionViewCell and for display data   ps. an add image button image is also in the array
    var imageArray: NSMutableArray = NSMutableArray()
    
    func setEvent(_ event: JSON_Event?) {
        self.event = event
    }
    
    deinit {
        print("--release EventDealSBViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        self.dealImage.delegate = self
        self.dealImage.dataSource = self
    }

    @IBAction func commitTouchUpInSide(_ sender: Any) {
        commitTouchUpInSide()
    }

    @IBAction func currentDateTouchUpInSide(_ sender: Any) {
        self.dealDate.maximumDate = Date()
        dealDate.date = Date()
    }
    
    @IBAction func currentLocationTouchUpInSide(_ sender: Any) {
        let navi = self.navigationController
        navi?.present(JTSelectLocationViewController(){ [weak self] (latitude,longitude) in
            let coor = CLLocationCoordinate2D(latitude: CLLocationDegrees().advanced(by: latitude), longitude: CLLocationDegrees().advanced(by: longitude))
            self?.setupLocation(location: coor)
        }, animated: true, completion: nil)
    }
    
    @IBAction func eventLocationTouchUpInSide(_ sender: Any) {
        if let e = self.event {
            if let lo = e.location {
                let point = AGSPoint(location: CLLocation(latitude: lo.latitude, longitude: lo.longitude))
                if let p = point {
                    let show = JTShowLocationViewController(p)
                    self.present(show, animated: true, completion: nil)
                }
            }
        }
    }

}
//func
extension EventDealSBViewController {
    
    fileprivate func commitTouchUpInSide() {
        setLoading(isLoading: true)

        if !checkInput() {
            setLoading(isLoading: false)
            return
        }
        
        let nRequest = getCreateProcessExecuteRequest()
        if let request = nRequest {
            createProcessExecute(request: request, complete: dealEventComplete)
        }else {
            AlertWithNoButton(view: self, title: msg_SomethingWrongTryAgain, message: "", preferredStyle: .alert, showTime: 1)
            setLoading(isLoading: false)
        }
    }
    
    fileprivate func setupLocation(location: CLLocationCoordinate2D?) {
        if let lo = location {
            dealLocation.setTitle("已选择位置（点击选择位置）", for: .normal)
            self.location = lo
        } else {
            dealLocation.setTitle("当前位置（点击选择位置）", for: .normal)
            self.location = nil
        }
    }
    
    fileprivate func createProcessExecute(request: URLRequest, complete: (() -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: { [weak self] (response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                if let xself = self {
                    AlertWithNoButton(view: xself, title: msg_Error, message: "\(msg_RequestError) \(error?.localizedDescription ?? "")", preferredStyle: .alert, showTime: 1)
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
            if let urlResponse = response {
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
                        let nId = data["id"].int
                        if let processId = nId {
                            if (self?.imageArray.count)! > 0 {
                                var images = [UIImage]()
                                if let arr  = self?.imageArray {
                                    for item in arr {
                                        let img = item as! UIImage
                                        if img.accessibilityIdentifier != self?.defaultAddImageAccessibilityIdentifier {
                                            images.append(img)
                                        }
                                    }
                                    let date = getDateFormatter(dateFormatter: "yyyy-MM-dd+HH:mm:ss").string(from: Date().addingTimeInterval(kTimeInteval))
                                    Image.instance.uploadImages(images: images, prid: String(processId), typenum: "2", actualtime: date, compress: Image.instance.wechatCompressImage(originalImg:), isCache: true, imagesUploadComplete: nil)
                                }
                            }
                            if complete != nil {
                                complete!()
                            }
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
    
    fileprivate func getCreateProcessExecuteRequest() -> URLRequest? {
        var urlRequest = URLRequest(url: URL(string: url_CreateProcessExecute)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        
        let jsonDic = getRequestData()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            urlRequest.httpShouldHandleCookies = true
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            return urlRequest
        }catch {
            printLog(message: "Create process execute. json data wrong\(error)")
            return nil
        }
    }
    
    private func getRequestData() -> Dictionary<String,Any> {
        var jsonDic = Dictionary<String,Any>()
        jsonDic["eid"] = self.event?.id
        jsonDic["processname"] = "毫无作用的事件处理名，系统自动添加，所有处理都是这个名字"
        jsonDic["statecode"] = "0001010400000003"
        jsonDic["uid"] = loginInfo?.userId
        if let location = self.location {
            jsonDic["location"] = getLocationDictionary(location: location)
        }
        let date = self.dealDate.date
        let d = date.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        jsonDic["actualtime"] = getDateFormatter(dateFormatter: kDateTimeFormate).string(from: d)
        jsonDic["remark"] = self.dealDetail.text
        
        return jsonDic
    }
    
    private func dealEventComplete() {
        backButtonAction()
        if let success = self.dealSuccess {
            success()
        }
    }

    private func getLocationDictionary(location: CLLocationCoordinate2D) -> Dictionary<String,Any> {
        var locationDic = Dictionary<String,Any>()
        locationDic["x"] = location.longitude
        locationDic["y"] = location.latitude
        return locationDic
    }
    
    private func checkInput() -> Bool {
        
        let remark = dealDetail.text
        let count = imageArray.count
        let remarkIsNil = ((remark == nil) || (remark?.isEmpty)!)
        let countIsNil = (count <= 1)
        if remarkIsNil && countIsNil {
            AlertWithNoButton(view: self, title: msg_PleaseFillInDealDetailOrDealImages, message: nil, preferredStyle: .alert, showTime: 1)
            return false
        }
        if self.location == nil {
            self.location = JTLocationManager.instance.location?.coordinate
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
extension EventDealSBViewController {
    
    fileprivate func setupUI(){
        
        setupBackButton()
        setupScrollView()
        setupTitle()
        setupInitBtnImage()
        setupCollectionView()
        setupShowEvent()
        setupDatePicker()
        setupJTPopInteractiveTransition()
    }
    
    private func setupJTPopInteractiveTransition() {
        self.jtViewControllerInteractiveTransition = JTViewControllerInteractiveTransition(fromVc: self, scrollView: self.scrollView ) { [weak self] () in
            self?.backButtonAction()
        }
    }
    
    private func setupDatePicker() {
        self.dealDate.maximumDate = Date()
    }
    
    private func setupShowEvent() {
        if let ev = self.event {
            self.eventName.text = ev.eventname
            self.eventType.text = ev.typecode_alias
            self.eventLevel.text = ev.levelcode_alias
        }
    }
    
    private func setupCollectionView(){
        self.dealImage.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        addLongPressListener()
    }
    
    private func setupScrollView(){
        scrollView.frame = self.view.frame
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.scrollsToTop = true
        scrollView.keyboardDismissMode = .onDrag
        scrollView.contentSize = CGSize(width: kScreenWidth, height: 900)
    }
    
    private func setupBackButton(){
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    @objc internal func backButtonAction(){
        let navi = self.navigationController
        navi?.popViewController(animated: true)
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
//collectionview
extension EventDealSBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate func setupInitBtnImage() {
        defaultAddImage?.accessibilityIdentifier = defaultAddImageAccessibilityIdentifier
        imageArray.add(defaultAddImage as Any)
        self.dealImage.reloadData()
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = imageArray.count
        let countPerRow = floor(self.dealImage.frame.width / CGFloat(collectionViewCellWidth))
        let rowCount = Int(ceil(CGFloat(count) / countPerRow))
        let height = rowCount * collectionViewCellHeight
        if self.dealImage.frame.height != CGFloat(height) {
            
            self.dealImageHeight.constant = CGFloat(height)
        }
        return count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath)
        let image = imageArray[indexPath.row] as? UIImage

        let imageView = UIImageView(frame: CGRect(x: 1, y: 1, width: 80, height: 80))
        imageView.backgroundColor = self.dealImage.backgroundColor
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
        longPress.minimumPressDuration = 1
        self.dealImage.addGestureRecognizer(longPress)
    }
    
    @objc internal func collectionViewLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let actionController = UIAlertController(title: "", message: "警告", preferredStyle: .actionSheet)
            let location = longPressGestureRecognizer.location(in: self.dealImage)
            let nIndexPath = self.dealImage.indexPathForItem(at: location)
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
                            self?.dealImage.reloadData()
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
extension EventDealSBViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func addImageAction(){
        let picker = UIImagePickerController()
        picker.delegate = self

        let actionController = UIAlertController(title: "提示", message: "拍照或从相册选择", preferredStyle: .actionSheet)
        let actionAlbum = UIAlertAction(title: "从相册选择", style: .default){ [weak self] (action) -> Void in
            picker.sourceType = .savedPhotosAlbum
            self?.navigationController?.present(picker, animated: true, completion: nil)
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
        self.dealImage.reloadData()
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


