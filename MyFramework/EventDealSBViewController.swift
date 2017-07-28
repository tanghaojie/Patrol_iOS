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
class EventDealSBViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventLevel: UILabel!
    @IBOutlet weak var eventLocation: UIImageView!
    @IBOutlet weak var dealLocation: UIButton!
    @IBOutlet weak var currentDate: UIButton!
    @IBOutlet weak var dealDate: UIDatePicker!
    @IBOutlet weak var dealDetail: UITextView!
    @IBOutlet weak var dealImage: UICollectionView!
    @IBOutlet weak var commit: UIButton!
    
    fileprivate let navigationTitle_Default = "事件处理"
    fileprivate let navigationTitle_Loading = "请稍后"
    fileprivate let defaultAddImageAccessibilityIdentifier = "de_add_image_iden"
    fileprivate let collectionViewCellIdentifier = "collectionViewCellIdentifier"
    fileprivate let titleActivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    fileprivate let titleLabel = UILabel()
    fileprivate let defaultAddImage = UIImage(named: "addImage")
    fileprivate let collectionViewCellHeight = 85
    fileprivate let collectionViewCellWidth = 85
    fileprivate let maxImageCount = 9

    fileprivate let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    fileprivate let imagePathName = "DealImages"
    
    fileprivate var location: CLLocationCoordinate2D?
    
    //for save self.eventImage collectionViewCell and for display data   ps. an add image button image is also in the array
    var imageArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dealImage.delegate = self
        self.dealImage.dataSource = self

        setupUI()
    }

    @IBAction func commitTouchUpInSide(_ sender: Any) {
        commitTouchUpInSide()
    }

    @IBAction func currentDateTouchUpInSide(_ sender: Any) {
        dealDate.date = Date()
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
    }
    
    private func createEvent(request: URLRequest, complete: (() -> Void)?) {
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                AlertWithNoButton(view: self, title: msg_Error, message: msg_RequestError, preferredStyle: .alert, showTime: 1)
                self.setLoading(isLoading: false)
                return
            }
            if (data?.isEmpty)! {
                AlertWithNoButton(view: self, title: msg_Error, message: msg_ServerNoResponse, preferredStyle: .alert, showTime: 1)
                self.setLoading(isLoading: false)
                return
            }
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    AlertWithNoButton(view: self, title: msg_Error, message: msg_HttpError, preferredStyle: .alert, showTime: 1)
                    self.setLoading(isLoading: false)
                    return
                }
                
                print("create event success \(Date().addingTimeInterval(kTimeInteval))")
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                let nMsg = json["msg"].string
                let data = json["data"]
                
                if let status = nStatus{
                    if(status != 0){
                        if let msg = nMsg{
                            AlertWithUIAlertAction(view: self, title: msg, message: "", preferredStyle: UIAlertControllerStyle.alert, uiAlertAction: UIAlertAction(title: msg_OK, style: .default, handler: nil))
                        }
                        self.setLoading(isLoading: false)
                        return
                    }
                    if data != JSON.null  {
                        let eventId = data["id"].int
                        if let images = self.eventModel.images {
                            if images.count > 0 {
                                let thisEventDir = self.saveImages(eventId: eventId!, images: images)
                                self.uploadImages(eventDir: thisEventDir)
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
            self.setLoading(isLoading: false)
        })
    }
    
    private func uploadImages(eventDir: String) {
        var images: [UIImage] = [UIImage]()
        let enumerator = FileManager.default.enumerator(atPath: eventDir)
        while let path = enumerator?.nextObject() as? String {
            let nImage = UIImage(named: "\(eventDir)/\(path)")
            if let image = nImage {
                images.append(image)
            }
        }
        if images.count > 0 {
            let dirName = URL(fileURLWithPath: eventDir).lastPathComponent
            let uid_eid = dirName.components(separatedBy: "_")
            if uid_eid.count < 2 {
                return
            }
            let eid = uid_eid[1]
            let date = getDateFormatter(dateFormatter: "yyyy-MM-dd+HH:mm:ss").string(from: Date().addingTimeInterval(kTimeInteval))
            Image.instance.uploadImages(images: images, prid: eid, typenum: "1", actualtime: date, eventImagesUploadComplete: eventImagesUploadCompleted)
        }
    }
    
    private func saveImages(eventId: Int, images: [UIImage]) -> String {
        let uid = loginInfo?.userId
        let directoryName = "\(uid ?? -1)_\(eventId)"
        var fullDir = cachePath?.appending("/\(imagePathName)")
        fullDir = fullDir?.appending("/\(directoryName)")
        Image.instance.saveImages(path: fullDir!, images: images, compressFunc: Image.instance.wechatCompressImage_720(originalImg:))
        
        return fullDir!
    }
    
    internal func eventImagesUploadCompleted(eventId: Int) {
        let uid = loginInfo?.userId
        let directoryName = "\(uid ?? -1)_\(eventId)"
        var fullDir = cachePath?.appending("/\(imagePathName)")
        fullDir = fullDir?.appending("/\(directoryName)")
        var x = ObjCBool(true)
        if FileManager.default.fileExists(atPath: fullDir!, isDirectory: &x) {
            try! FileManager.default.copyItem(atPath: fullDir!, toPath: "\(fullDir!)_")
        }
    }
    
    private func getCreateEventRequest() -> URLRequest? {
        var urlRequest = URLRequest(url: URL(string: url_CreateProcessExecute)!)
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
        jsonDic["eid"] = ""
        jsonDic["processname"] = ""
        jsonDic["statecode"] = ""
        jsonDic["uid"] = loginInfo?.userId
        jsonDic["location"] = ""
        jsonDic["actualtime"] = ""
        jsonDic["remark"] = ""

        return jsonDic
    }
    
    private func checkInput() -> Bool {
        
        let remark = dealDetail.text
        let count = imageArray.count
        if (remark == nil || (remark?.isEmpty)!) || (count <= 0 ) {
            AlertWithNoButton(view: self, title: msg_PleaseFillInDealDetailOrDealImages, message: nil, preferredStyle: .alert, showTime: 1)
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
extension EventDealSBViewController {
    
    fileprivate func setupUI(){
        
        setupBackButton()
        setupScrollView()
        setupTitle()
        setupInitBtnImage()
        setupCollectionView()
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
            self.dealImage.frame = CGRect(x: self.dealImage.frame.minX, y: self.dealImage.frame.minY, width: self.dealImage.frame.width, height: CGFloat(height))
            self.commit.frame = CGRect(x: self.commit.frame.minX, y: self.dealImage.frame.maxY + 10, width: self.commit.frame.width, height: self.commit.frame.height)
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
            }
        }
    }
    
    fileprivate func addLongPressListener(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.collectionViewLongPress))
        longPress.minimumPressDuration = 1
        self.dealImage.addGestureRecognizer(longPress)
    }
    
    internal func collectionViewLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let actionController = UIAlertController(title: "", message: "警告", preferredStyle: .actionSheet)
            let location = longPressGestureRecognizer.location(in: self.dealImage)
            let nIndexPath = self.dealImage.indexPathForItem(at: location)
            if nIndexPath != nil{
                let image = self.imageArray[nIndexPath!.row] as? UIImage
                if image != nil {
                    if image?.accessibilityIdentifier != defaultAddImageAccessibilityIdentifier {
                        let actionDel = UIAlertAction(title: "删除", style: .default){ (_) -> Void in
                            self.imageArray.remove(image as Any)
                            self.dealImage.reloadData()
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
        self.dealImage.reloadData()
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

