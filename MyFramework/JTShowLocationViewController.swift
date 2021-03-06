//
//  ShowLocationViewController.swift
//  MyFramework
//
//  Created by JT on 2017/8/2.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTShowLocationViewController: UIViewController {

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
    
    deinit {
        print("----release JTShowLocationViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView.zoom(toScale: 10000, withCenter: point, animated: true)
    }

}

extension JTShowLocationViewController {
    
    fileprivate func setupUI() {
        
        setupMapView()
        setupBackButton()
        setupLocationButton()
    }
    
    private func setupMapView() {
        
        SCGISUtility.registerESRI()
        mapView = AGSMapView()

        mapView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScrennHeight)
        self.mapView.locationDisplay.startDataSource()

        mapView.gridLineWidth = 10
        graphicslayer.isVisible = true
        mapView.layerDelegate = self

        let scgisTilemapServerLayer = SCGISTilemapServerLayer(serviceUrlStr: scgisTiledMap_DLG, token: nil, cacheType: SCGISTilemapCacheTypeSqliteDB)
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
        backBtn.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    @objc internal func backButtonAction() {
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
    
    @objc internal func locationButtonClicked() {
        let location = self.mapView.locationDisplay.location
        if let loca = location {
            self.mapView.center(at: loca.point, animated: true)
        }
    }
    
    fileprivate func setPictureMarkerSymbol() {
        let pictureMarkerSymbol = AGSPictureMarkerSymbol()
        pictureMarkerSymbol.image = UIImage(named: "centerPoint")
        let graphic = AGSGraphic(geometry: self.point, symbol: pictureMarkerSymbol, attributes: nil)
        self.graphicslayer.addGraphic(graphic)
    }

}

extension JTShowLocationViewController: AGSMapViewLayerDelegate {
    
    func mapViewDidLoad(_ mapView: AGSMapView!) {
        self.mapView.locationDisplay.startDataSource()
        self.mapView.locationDisplay.autoPanMode = .off
        //self.mapView.zoom(toScale: 10000, withCenter: point, animated: true)
    }
    
}

