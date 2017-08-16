//
//  SelectLocationViewController.swift
//  MyFramework
//
//  Created by JT on 2017/8/1.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTSelectLocationViewController: UIViewController {

    fileprivate var mapView: AGSMapView!
    fileprivate var completeFunc: ((Double,Double) -> Void)?
    fileprivate let minScale: Double = 5300
    fileprivate let maxScale: Double = 2900

    init(_ complete: ((Double,Double) -> Void)?){
        self.completeFunc = complete
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension JTSelectLocationViewController {
    
    fileprivate func setupUI() {
        
        setupMapView()
        setupBackButton()
        setupLocationButton()
        setupCenterPoint()
        setupOKButton()
    }
    
    private func setupMapView() {
        
        mapView = AGSMapView()
        
        //SCGISUtility.registerESRI()
        
        mapView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScrennHeight)
        mapView.layerDelegate = self
        mapView.gridLineWidth = 10
        mapView.maxScale = maxScale
        mapView.minScale = minScale
        
        mapView.locationDisplay.dataSource = JTAGSLocationDisplayDataSource.instance
        
        let scgisTilemapServerLayer = SCGISTilemapServerLayer(serviceUrlStr: scgisTiledMap_DLG, token: nil)
        if(scgisTilemapServerLayer != nil){
            self.mapView.addMapLayer(scgisTilemapServerLayer)
        }

        self.view.addSubview(mapView)
    }
    
    private func setupBackButton() {
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let backBtn = UIButton(frame: CGRect(x: 15, y: 25, width: 80, height: 80))
        backBtn.setImage(img, for: .normal)
        backBtn.contentVerticalAlignment = .top
        backBtn.contentHorizontalAlignment = .left
        backBtn.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    internal func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupLocationButton() {
        let wh: CGFloat = 50
        let btn = UIButton(frame: CGRect(x: kScreenWidth - wh - 20, y: self.view.frame.height - wh - 20, width: wh, height: wh))
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        let img = UIImage(named: "location")
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    internal func locationButtonClicked() {
        let location = JTLocationManager.instance.location
        if let loca = location {
            let point = AGSPoint(location: loca)
            self.mapView.zoom(toScale: minScale, withCenter: point, animated: true)
        }
    }
    
    private func setupCenterPoint() {
        let w: CGFloat = 38
        let h: CGFloat  = 38
        let x = (kScreenWidth - w) / 2
        let y = kScrennHeight / 2 - h
        let imgView = UIImageView(frame: CGRect(x: x, y: y, width: w, height: h))
        imgView.image = UIImage(named: "centerPoint")
        self.view.addSubview(imgView)
    }
    
    private func setupOKButton() {
        let w: CGFloat = 150
        let h: CGFloat = 50
        let x = (kScreenWidth - w) / 2
        let y = kScrennHeight - h - 20
        let btn = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
        btn.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        btn.backgroundColor = UIColor(red: 0, green: 94, blue: 149)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        //btn.backgroundColor = UIColor(red: 0, green: 122, blue: 255)
        
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        self.view.addSubview(btn)
    }
    
    internal func okButtonAction() {
        if let com = self.completeFunc {
            let p = mapView.toMapPoint(self.mapView.center)
            if let point = p {
                let latitude = point.y
                let longitude = point.x
                com(latitude,longitude)
                backButtonAction()
            }
        }
    }
    
}

extension JTSelectLocationViewController: AGSMapViewLayerDelegate {
    
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        //let map = self.mapView.mapLayers[0] as! AGSTiledLayer
        //let envelop = map.initialEnvelope
        self.mapView.zoom(toScale: minScale, animated: true)
        //self.mapView.zoom(to: envelop, animated: false)
        self.mapView.locationDisplay.startDataSource()
        self.mapView.locationDisplay.autoPanMode = .default
    }

}