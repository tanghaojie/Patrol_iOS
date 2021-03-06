//
//  MainViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class MainViewController: UIViewController, AGSMapViewLayerDelegate {

    fileprivate var mapView: AGSMapView! = AGSMapView()
    
    fileprivate var scgisTilemapServerLayer_DLG: SCGISTilemapServerLayer!
    fileprivate var scgisTilemapServerLayer_DOM: SCGISTilemapServerLayer!
    fileprivate var featureLayer: AGSFeatureLayer!
    
    fileprivate var layerBtn: UIButton!
    fileprivate var layerView: UIView!
    
    fileprivate let dark = UIColor(red: 73, green: 73, blue: 75)
    fileprivate let normal = UIColor(red: 142, green: 142, blue: 144)
    
    fileprivate var timer1s: Timer!
    fileprivate var timer10s: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setData()
        
        timer10s = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timer10Fire), userInfo: nil, repeats: true)
        timer1s = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer1Fire), userInfo: nil, repeats: true)
        
        JTLocationManager.instance.startUpdatingLocation()
        JTLocationManager.instance.startUpdatingHeading()
    }
    
    deinit {
        print("--release MainViewController")
    }
    
    func selfDismiss() {
        timer1s.invalidate()
        timer1s = nil
        timer10s.invalidate()
        timer10s = nil
        
        //JTLocationManager.instance.stopUpdatingHeading()
        //JTLocationManager.instance.stopUpdatingLocation()

        self.dismiss(animated: true) { [weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }
    }

}

extension MainViewController {
    
    fileprivate func setupUI() {
        self.setupMapView()
        self.setupBottomBar()
        self.addTapListener()
    }
    
    fileprivate func addTapListener(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTap(tapGestureRecognizer: )))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc internal func viewTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if let layerV = self.layerView {
            let location = tapGestureRecognizer.location(in: layerV)
            let w = layerV.frame.width
            let h = layerV.frame.height
            if location.x < 0 || location.x > w || location.y < 0 || location.y > h {
                self.layerView?.removeFromSuperview()
                self.layerView = nil
            }
        }
    }
    
    private func setupMapView(){
        
        SCGISUtility.registerESRI()
        
        mapView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScrennHeight - kMainBottomTabBarHeight)
        mapView.layerDelegate = self
        mapView.gridLineWidth = 10
        
        mapView.locationDisplay.dataSource = JTAGSLocationDisplayDataSource.instance

        self.scgisTilemapServerLayer_DLG = SCGISTilemapServerLayer(serviceUrlStr: scgisTiledMap_DLG, token: nil, cacheType: SCGISTilemapCacheTypeSqliteDB)
        if(scgisTilemapServerLayer_DLG != nil){
            self.mapView.addMapLayer(scgisTilemapServerLayer_DLG)
        }
        
        self.scgisTilemapServerLayer_DOM = SCGISTilemapServerLayer(serviceUrlStr: scgisTiledMap_DOM, token: nil, cacheType: SCGISTilemapCacheTypeSqliteDB)
        if(scgisTilemapServerLayer_DOM != nil){
            self.mapView.addMapLayer(scgisTilemapServerLayer_DOM)
            scgisTilemapServerLayer_DOM.isVisible = false
        }

        self.featureLayer = AGSFeatureLayer(url: URL(string: eshaProtrait), mode: .onDemand)
        if featureLayer != nil {
            featureLayer?.opacity = 0.5
            let symbol = AGSSimpleLineSymbol(color: UIColor(red: 231, green: 71, blue: 94 ))
            symbol?.width = 2
            featureLayer?.renderer = AGSSimpleRenderer(symbol: symbol)
            self.mapView.addMapLayer(featureLayer)
        }

        self.view.addSubview(mapView)
//        mapView.snp.makeConstraints({ (make) in
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.top.equalTo(0)
//            make.bottom.equalTo(-kMainBottomTabBarHeight)
//        })
        
        setupLayerButton(pView : mapView)
        setupAddEventButton(pView : mapView)
        setupLocationButton(pView: mapView)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    private func setupLayerButton(pView : UIView){
        self.layerBtn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 120, width: 40, height: 40))
        self.layerBtn?.backgroundColor = .clear
        self.layerBtn?.layer.borderColor = UIColor.black.cgColor
        let img = UIImage(named: "layer")
        self.layerBtn?.setImage(img, for: .normal)
        self.layerBtn?.addTarget(self, action: #selector(layerButtonAction), for: .touchUpInside)
        pView.addSubview(self.layerBtn!)
    }
    
    @objc internal func layerButtonAction() {
        setupLayerSelectView()
    }
    
    private func setupLayerSelectView() {
        let w: CGFloat = kScreenWidth / 3 * 2
        let h: CGFloat = 150
        let x: CGFloat = self.layerBtn!.frame.maxX - w
        let y: CGFloat = self.layerBtn!.frame.minY
        self.layerView = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        self.layerView?.backgroundColor = .gray
        
        let btn1 = UIButton(frame: CGRect(x: 0, y: 0, width: w, height: 50))
        btn1.setTitle("底图", for: .normal)
        btn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        if scgisTilemapServerLayer_DLG.isVisible {
            btn1.backgroundColor = dark
            btn1.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn1.backgroundColor = normal
            btn1.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        btn1.addTarget(self, action: #selector(layerBtn1Action(btn:)), for: .touchUpInside)
        
        let btn2 = UIButton(frame: CGRect(x: 0, y: 100, width: w, height: 50))
        btn2.setTitle("管线", for: .normal)
        btn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        if featureLayer.isVisible {
            btn2.backgroundColor = dark
            btn2.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn2.backgroundColor = normal
            btn2.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        btn2.addTarget(self, action: #selector(layerBtn2Action(btn:)), for: .touchUpInside)
        
        let btn3 = UIButton(frame: CGRect(x: 0, y: 50, width: w, height: 50))
        btn3.setTitle("影像", for: .normal)
        btn3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        if scgisTilemapServerLayer_DOM.isVisible {
            btn3.backgroundColor = dark
            btn3.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn3.backgroundColor = normal
            btn3.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        btn3.addTarget(self, action: #selector(layerBtn3Action(btn:)), for: .touchUpInside)
        
        self.layerView?.addSubview(btn1)
        self.layerView?.addSubview(btn2)
        self.layerView?.addSubview(btn3)
        
        self.view.addSubview(self.layerView!)
    }
    
    @objc func layerBtn1Action(btn: UIButton) {
        scgisTilemapServerLayer_DLG.isVisible = !scgisTilemapServerLayer_DLG.isVisible
        //btn.backgroundColor = scgisTilemapServerLayer_DLG.isVisible ? dark : normal
        if scgisTilemapServerLayer_DLG.isVisible {
            btn.backgroundColor = dark
            btn.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn.backgroundColor = normal
            btn.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }

    @objc func layerBtn2Action(btn: UIButton) {
        featureLayer.isVisible = !featureLayer.isVisible
        //btn.backgroundColor = featureLayer.isVisible ? dark : normal
        if featureLayer.isVisible {
            btn.backgroundColor = dark
            btn.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn.backgroundColor = normal
            btn.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }
    
    @objc func layerBtn3Action(btn: UIButton) {
        scgisTilemapServerLayer_DOM.isVisible = !scgisTilemapServerLayer_DOM.isVisible
        //btn.backgroundColor = scgisTilemapServerLayer_DOM.isVisible ? dark : normal
        if scgisTilemapServerLayer_DOM.isVisible {
            btn.backgroundColor = dark
            btn.setImage(UIImage(named: "check"), for: .normal)
        } else {
            btn.backgroundColor = normal
            btn.setImage(UIImage(named: "uncheck"), for: .normal)
        }
    }

    private func setupAddEventButton(pView : UIView){
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 180, width: 40, height: 40))
        btn.backgroundColor = .clear
        let img = UIImage(named: "eventReport")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(addEventButtonClicked), for: .touchUpInside)
        pView.addSubview(btn)
    }
    
    @objc func addEventButtonClicked() {
        self.present(EventReportViewController(reportSuccessFunc: nil), animated: true, completion: nil)
    }
    
    private func setupLocationButton(pView : UIView) {
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: self.mapView.frame.height - 40 - 20, width: 40, height: 40))
        //let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        let img = UIImage(named: "location")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        pView.addSubview(btn)
//        btn.snp.makeConstraints({ (make) in
//            make.width.equalTo(40)
//            make.height.equalTo(40)
//            make.right.equalTo(-20)
//            make.bottom.equalTo(-20)
//        })
        pView.bringSubviewToFront(btn)
    }
    
    @objc func locationButtonClicked() {
        let location = JTLocationManager.instance.location
        if let loca = location {
            let point = AGSPoint(location: loca)
            self.mapView.center(at: point, animated: true)
            self.mapView.locationDisplay.autoPanMode = .default
        }
    }
    
    private func setupBottomBar(){

        let titles = ["任务","事件","我的"]
        let images = ["task","event","my"]
        let task: (() -> ())? = { [weak self] in
            self?.jumpToTask()
        }
        let event: (() -> ())? = { [weak self] in
            self?.jumpToEvent()
        }
        let home: (() -> ())? = { [weak self] in
            self?.jumpToHome()
        }
        
        let jumps = [ task , event , home ]

        let frame = CGRect(x: 0, y: kScrennHeight - kMainBottomTabBarHeight, width: kScreenWidth, height: kMainBottomTabBarHeight)
        let customTBV = JTTabbarView(frame: frame, titles: titles , images : images ,jumps : jumps)
        //let customTBV = JTTabbarView(width: Int(kScreenWidth), height: Int(kMainBottomTabBarHeight), titles: titles , images : images ,jumps : jumps)
        self.view.addSubview(customTBV)
//        customTBV.snp.makeConstraints({ (make) in
//            make.bottom.equalTo(0)
//            make.left.equalTo(0)
//            make.right.equalTo(0)
//            make.height.equalTo(kMainBottomTabBarHeight)
//        })
    }
}

//map
extension MainViewController {
    
    func mapViewDidLoad(_ mapView: AGSMapView!) {
    
        let map = self.mapView.mapLayers[0] as! AGSTiledLayer
        let envelop = map.initialEnvelope

        self.mapView.zoom(to: envelop, animated: false)

        //if !self.mapView.locationDisplay.isDataSourceStarted {
            self.mapView.locationDisplay.startDataSource()
        //}
        self.mapView.locationDisplay.autoPanMode = .default
    }

}

extension MainViewController{
    
    fileprivate func setData(){
        let request = TaskSBViewController.getCurrentTaskRequest(userId: (loginInfo?.userId)!)
        currentTaskAsyncConnect(urlRequest: request)
    }
    
    private func currentTaskAsyncConnect(urlRequest : URLRequest){
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: { [weak self] (response : URLResponse?, data : Data?, error : Error?) -> Void in
            if let urlResponse = response{
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if(statusCode != 200){
                    return
                }
                if(error != nil){
                    return
                }
                if(data?.isEmpty)!{
                    return
                }
                let json = (try? JSON(data : data!))!
                let nStatus = json["status"].int
                let ndata = json["data"]
                if let status = nStatus{
                    if(status != 0){
                        return
                    }
                    if ndata != JSON.null {
                        self?.jumpToTask()
                    }
                }
            }else{
                return
            }
        })
    }
}

extension MainViewController {
    
    fileprivate func jumpToTask(){
        self.present(TaskViewController(), animated: true, completion: nil)
    }
    
    fileprivate func jumpToHome(){
        self.present(HomeViewController(), animated: true, completion: nil)
    }
    
    fileprivate func jumpToEvent(){
        self.present(EventViewController(), animated: true, completion: nil)
    }

}

extension MainViewController {

    @objc fileprivate func timer10Fire() {
        let ntaskId = loginInfo?.taskId
        if let taskId = ntaskId {
            let nPoints = getLocations_Dic()
            if let points = nPoints {
                var urlRequest = URLRequest(url: URL(string: url_UploadPoints)!)
                urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
                urlRequest.httpMethod = HttpMethod.Post.rawValue
                do {
                    var jsonDic = Dictionary<String,Any>()
                    jsonDic["uid"] = loginInfo?.userId
                    jsonDic["tid"] = taskId
                    jsonDic["points"] = points
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)

                    urlRequest.httpBody = jsonData
                    urlRequest.httpShouldHandleCookies = true
                    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    
                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main, completionHandler: {(response : URLResponse?, data : Data?, error : Error?) -> Void in
                        if let urlResponse = response{
                            let httpResponse = urlResponse as! HTTPURLResponse
                            let statusCode = httpResponse.statusCode
                            if(statusCode != 200){
                                return
                            }
                            if(error != nil){
                                return
                            }
                            if(data?.isEmpty)!{
                                return
                            }
                            locationWithDate.removeFirst(points.count)
           
                            //this is for test
                            if TaskSBViewController.isLog {
                                let u = docPath?.appending("/\(taskId)")
                                let file = u?.appending("/system10s.txt")
                                let url = URL(fileURLWithPath: file!)
                                if !FileManager.default.fileExists(atPath: url.path) {
                                    FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
                                }
                                
                                let fileHandle = try? FileHandle(forWritingTo: url)
                                if let handle = fileHandle {
                                    handle.seekToEndOfFile()
                                    
                                    var str = "\nupload success"
                                    for xp in points {
                                        str = str.appending("\n\(String(describing: xp["t"]!))   \(String(format: "%.12f", xp["x"] as! Double))  \(String(format: "%.12f", xp["y"] as! Double))")
                                    }
                                    handle.write(str.data(using: String.Encoding.utf8)!)
                                    handle.closeFile()
                                }
                            }
                            //end this is for test
                        }
                    })
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    @objc fileprivate func timer1Fire() {
        if loginInfo?.taskId != nil{
            let coordinate = JTLocationManager.instance.location
            if let coor = coordinate {
                let dateTime = Date().addingTimeInterval(kTimeInteval)
                //this is for test
                if TaskSBViewController.isLog {
                    let logStr = "\(dateTime)   \(String(format: "%.12f", coor.coordinate.longitude))   \(String(format: "%.12f", coor.coordinate.latitude))"
                    let u = docPath?.appending("/\((loginInfo?.taskId)!)")
                    let file = u?.appending("/system1s.txt")
                    let url = URL(fileURLWithPath: file!)
                    if !FileManager.default.fileExists(atPath: url.path) {
                        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
                    }
                    let fileHandle = try? FileHandle(forWritingTo: url)
                    if let handle = fileHandle {
                        handle.seekToEndOfFile()
                        handle.write("\n\(logStr)".data(using: String.Encoding.utf8)!)
                        handle.closeFile()
                    }
                }
                //end this is for test
                sparseLocationArray()
                locationWithDate.append(TCoordinate(location: coor.coordinate, time: dateTime))
            }
        }
    }
    
   
    
    private func getLocations_Dic() -> [Dictionary<String,Any>]? {
        let count = locationWithDate.count
        if count <= 0 {
            return nil
        }
        var result = [Dictionary<String,Any>]()
        var nowSec : Int? = nil
        for index in 0..<count{
            let tl = locationWithDate[index]
            let df = getDateFormatter(dateFormatter: "HH:mm:ss")
            let strTime = df.string(from: tl.time)
            let xTime = strTime.split(separator: ":").map(String.init)
            let hour = Int(xTime[0])
            let minute = Int(xTime[1])
            let second = Int(xTime[2])
            if(nowSec == second){
                continue
            }
            nowSec = second
                
            let secondOfCurrentDay = hour! * 3600 + minute! * 60 + second!
            var dicc = Dictionary<String,Any>()
            dicc["x"] = tl.location.longitude
            dicc["y"] = tl.location.latitude
            dicc["t"] = secondOfCurrentDay
            result.append(dicc)
        }
        return result
    }
    
    private func sparseLocationArray() {
        if locationWithDate.count > locationArrayMax {
            dangerLock.lock()
            let nowCount = locationWithDate.count
            if nowCount > locationArrayMax {
                var temp = [TCoordinate]()
                for i in stride(from: 0, to: nowCount, by: 2) {
                    if let last = temp.last {
                        let p2 = locationWithDate[i]
                        if last.location.longitude == p2.location.longitude && last.location.latitude == p2.location.latitude {
                            continue
                        }
                    }
                    temp.append(locationWithDate[i])
                }
                locationWithDate = temp
            }
            dangerLock.unlock()
        }
    }
    
}




