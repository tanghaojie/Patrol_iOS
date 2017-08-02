//
//  MainViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController,AGSMapViewLayerDelegate {
    
    var mapView: AGSMapView! = AGSMapView()
    let location = MLocationManager.instance
    
    var scgisTilemapServerLayer: SCGISTilemapServerLayer!
    var featureLayer: AGSFeatureLayer!
    
    var layerBtn: UIButton!
    var layerView: UIView?
    
    let dark = UIColor(red: 73, green: 73, blue: 75)
    let normal = UIColor(red: 142, green: 142, blue: 144)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setData()
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timer10Fire), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer1Fire), userInfo: nil, repeats: true)
    }

}

extension MainViewController {
    
    fileprivate func setupUI(){
        self.setupMapView()
        self.setupBottomBar()
        self.addTapListener()
    }
    
    fileprivate func addTapListener(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTap(tapGestureRecognizer: )))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    internal func viewTap(tapGestureRecognizer: UITapGestureRecognizer) {
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
        self.scgisTilemapServerLayer = SCGISTilemapServerLayer(serviceUrlStr: "http://www.scgis.net.cn/imap/imapserver/defaultrest/services/scmobile_dlg/", token: nil)
        if(scgisTilemapServerLayer != nil){
            self.mapView.addMapLayer(scgisTilemapServerLayer)
        }

        self.featureLayer = AGSFeatureLayer(url: URL(string: "http://119.6.30.131:6080/arcgis/rest/services/PipeLineES/MapServer/0"), mode: .onDemand)
        if featureLayer != nil {
            featureLayer?.opacity = 0.5
            let symbol = AGSSimpleLineSymbol(color: UIColor(red: 231, green: 71, blue: 94 ))
            symbol?.width = 2
            featureLayer?.renderer = AGSSimpleRenderer(symbol: symbol)
            self.mapView.addMapLayer(featureLayer)
        }

        self.view.addSubview(mapView)
        
        setupLayerButton(pView : mapView)
        setupAddEventButton(pView : mapView)
        setupLocationButton(pView: mapView)
    }
    
    private func setupLayerButton(pView : UIView){
        self.layerBtn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 120, width: 40, height: 40))
        self.layerBtn.backgroundColor = .clear
        self.layerBtn.layer.borderColor = UIColor.black.cgColor
        let img = UIImage(named: "layer")
        self.layerBtn.setImage(img, for: .normal)
        self.layerBtn.addTarget(self, action: #selector(layerButtonAction), for: .touchUpInside)
        pView.addSubview(self.layerBtn)
    }
    
    internal func layerButtonAction() {
        setupLayerSelectView()
    }
    
    private func setupLayerSelectView() {
        let w: CGFloat = kScreenWidth / 3 * 2
        let h: CGFloat = 100
        let x: CGFloat = self.layerBtn.frame.maxX - w
        let y: CGFloat = self.layerBtn.frame.minY
        self.layerView = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        self.layerView?.backgroundColor = .gray
        
        let btn1 = UIButton(frame: CGRect(x: 0, y: 0, width: w, height: 50))
        let btn2 = UIButton(frame: CGRect(x: 0, y: 50, width: w, height: 50))
        
        
        btn1.backgroundColor = scgisTilemapServerLayer.isVisible ? dark : normal
        btn2.backgroundColor = featureLayer.isVisible ? dark : normal
        
        btn1.setTitle("底图", for: .normal)
        btn2.setTitle("管线", for: .normal)
        btn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        btn1.addTarget(self, action: #selector(layerBtn1Action(btn:)), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(layerBtn2Action(btn:)), for: .touchUpInside)
        
        self.layerView?.addSubview(btn1)
        self.layerView?.addSubview(btn2)
        
        self.view.addSubview(self.layerView!)
    }
    
    func layerBtn1Action(btn: UIButton) {
        scgisTilemapServerLayer.isVisible = !scgisTilemapServerLayer.isVisible
        btn.backgroundColor = scgisTilemapServerLayer.isVisible ? dark : normal
    }
    
    func layerBtn2Action(btn: UIButton) {
        featureLayer.isVisible = !featureLayer.isVisible
        btn.backgroundColor = featureLayer.isVisible ? dark : normal
    }

    private func setupAddEventButton(pView : UIView){
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: 180, width: 40, height: 40))
        btn.backgroundColor = .clear
        let img = UIImage(named: "eventReport")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(addEventButtonClicked), for: .touchUpInside)
        pView.addSubview(btn)
    }
    
    func addEventButtonClicked() {
        self.present(EventReportViewController(), animated: true, completion: nil)
    }
    
    private func setupLocationButton(pView : UIView){
        let btn = UIButton(frame: CGRect(x: kScreenWidth - 20 - 40, y: pView.frame.height - 40 - 20, width: 40, height: 40))
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        let img = UIImage(named: "location")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        pView.addSubview(btn)
    }
    
    func locationButtonClicked(){
        startLocationDisplay(with: AGSLocationDisplayAutoPanMode.default)
    }
    
    func startLocationDisplay(with autoPanMode: AGSLocationDisplayAutoPanMode){
        self.mapView.locationDisplay.autoPanMode = autoPanMode
    }
    
    private func setupBottomBar(){
        let frame = CGRect(x: 0, y: kScrennHeight - kMainBottomTabBarHeight, width: kScreenWidth, height: kMainBottomTabBarHeight)
        
        let titles = ["任务","事件","我的"]
        let images = ["task","event","my"]
        let jumps : Array<(()->())?>  = [ jumpToTask , jumpToEvent , jumpToHome  ]
        
        let customTBV = CustomTabbarView(frame: frame, titles: titles , images : images ,jumps : jumps)
        
//        let layer = CALayer()
//        layer.frame = CGRect(x: 0, y: 0, width: customTBV.frame.width, height: 1)
//        layer.backgroundColor = UIColor.black.cgColor
//        customTBV.layer.addSublayer(layer)
        self.view.addSubview(customTBV)
    }
}

//map
extension MainViewController{
    
    func mapViewDidLoad(_ mapView: AGSMapView!) {
    
        let map = self.mapView.mapLayers[0] as! AGSTiledLayer
        let envelop = map.initialEnvelope

        self.mapView.zoom(to: envelop, animated: false)
        self.mapView.locationDisplay.startDataSource()
        self.mapView.locationDisplay.autoPanMode = .default
    }

}

extension MainViewController{
    
    fileprivate func setData(){
        let request = TaskSBViewController.getCurrentTaskRequest(userId: (loginInfo?.userId)!)
        currentTaskAsyncConnect(urlRequest: request)
    }
    
    private func currentTaskAsyncConnect(urlRequest : URLRequest){
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
                let json = JSON(data : data!)
                let nStatus = json["status"].int
//                let nMsg = json["msg"].string
                let ndata = json["data"]
                if let status = nStatus{
                    if(status != 0){
                        return
                    }
                    if ndata != JSON.null {
                        self.jumpToTask()
                    }
                }
            }else{
                return
            }
        })
    }
    
}

extension MainViewController{
    
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

extension MainViewController{

    @objc fileprivate func timer10Fire(){

        let ntaskId = loginInfo?.taskId
        if let taskId = ntaskId {
            let nPoints = getLocations_Dic()
            if let points = nPoints {
                
                print("fire  \(Date().addingTimeInterval(kTimeInteval))")
                
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
                            print("fire success \(Date().addingTimeInterval(kTimeInteval))")
//                            let json = JSON(data : data!)
//                            let nStatus = json["status"].int
//                            let nMsg = json["msg"].string
                        }
                    })
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    @objc fileprivate func timer1Fire(){
        if loginInfo?.taskId != nil{
            let coordinate = location.location
            if let coor = coordinate {
                let dateTime = Date().addingTimeInterval(kTimeInteval)
                print("coor:\(coor.coordinate.longitude)   \(coor.coordinate.latitude)   \(dateTime)")
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
        for _ in 1...count{
            let x = locationWithDate.popLast()
            if let tl = x {
                let df = getDateFormatter(dateFormatter: "HH:mm:ss")
                let strTime = df.string(from: tl.time)
                let xTime = strTime.characters.split(separator: ":").map(String.init)
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
        }
        return result.reversed()
    }
    
}




