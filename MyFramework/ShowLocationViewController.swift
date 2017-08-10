//
//  ShowLocationViewController.swift
//  MyFramework
//
//  Created by JT on 2017/8/2.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class ShowLocationViewController: UIViewController {

    fileprivate var mapView: AGSMapView!
    fileprivate let graphicslayer = AGSGraphicsLayer()
    fileprivate let point: AGSPoint!
    
    init(_ point: AGSPoint!){
        self.point = point
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setPictureMarkerSymbol()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mapView.zoom(toScale: 10000, withCenter: self.point, animated: true)
    }

}

extension ShowLocationViewController {
    
    fileprivate func setupUI() {
        
        setupMapView()
        setupBackButton()
        setupLocationButton()
    }
    
    private func setupMapView() {
        
        mapView = AGSMapView()

        mapView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScrennHeight)
        self.mapView.locationDisplay.startDataSource()

        mapView.gridLineWidth = 10
        graphicslayer.isVisible = true

        let scgisTilemapServerLayer = SCGISTilemapServerLayer(serviceUrlStr: scgisTiledMap, token: nil)
        if(scgisTilemapServerLayer != nil){
            self.mapView.addMapLayer(scgisTilemapServerLayer)
        }
        
        mapView.addMapLayer(graphicslayer)

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
        let location = MLocationManager.instance.location
        if let loca = location {
            let point = AGSPoint(location: loca)
            self.mapView.zoom(toScale: 10000, withCenter: point, animated: true)
        }
    }
    
    fileprivate func setPictureMarkerSymbol() {
        let pictureMarkerSymbol = AGSPictureMarkerSymbol()
        pictureMarkerSymbol.image = UIImage(named: "centerPoint")
        let graphic = AGSGraphic(geometry: self.point, symbol: pictureMarkerSymbol, attributes: nil)
        self.graphicslayer.addGraphic(graphic)
    }

}

