//
//  MyViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var cacheSizeLabel: UILabel!
    fileprivate var cacheActivityIndicatorView: UIActivityIndicatorView!
    
    fileprivate var tableViewDisplay = Dictionary<IndexPath,(UITableViewCell) -> UITableViewCell>()
    fileprivate var tableViewSelectAction = Dictionary<IndexPath,() -> Void>()
    
    fileprivate let tableViewHeaderHeight: CGFloat = 200
    fileprivate let tableViewHeaderImageWH: CGFloat = 180
    fileprivate let tableViewRowHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setTableViewDisplay()
        setTableViewSelectAction()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    


}

extension MyViewController {
    
    fileprivate func setupUI() {

        setupBackButton()
        setupTitle()
        
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView = UITableView()
        self.tableView.frame = self.view.frame
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.bounces = true
        self.tableView.alwaysBounceVertical = true
        self.tableView.alwaysBounceHorizontal = false
        self.tableView.scrollsToTop = true
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.tableFooterView = UIView()

        self.registCell()
        self.tableView.backgroundColor = UIColor(red: 245, green: 245, blue: 245)

        self.tableView.tableHeaderView = setupTableViewHeaderView()
        
        self.view = tableView
    }
    
    private func setupTableViewHeaderView() -> UIView {

        let headView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: tableViewHeaderHeight))
        headView.backgroundColor = .yellow
        
        let imgView = UIImageView(frame: CGRect(x: (kScreenWidth - tableViewHeaderImageWH) / 2, y: (tableViewHeaderHeight - tableViewHeaderImageWH) / 2, width: tableViewHeaderImageWH, height: tableViewHeaderImageWH))
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = tableViewHeaderImageWH / 2
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.black.cgColor
        
        HeadPortrait(imageView: imgView)
        headView.addSubview(imgView)
        
        return headView
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
    
    private func setupTitle() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        self.navigationItem.titleView = view
        let wid : CGFloat = 75.0//4 chn charactor
        let hei : CGFloat = 44.0
        let x : CGFloat = 32.5
        let y : CGFloat = 0
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: x, y: y, width: wid, height: hei)
        titleLabel.text = "我的"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }
    
    
}

extension MyViewController {
    
    fileprivate func HeadPortrait(imageView: UIImageView) {
        Image.instance.getImageInfo(prid: (loginInfo?.userId)!, typenum: 0) {(image,index) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }
}

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registCell() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableViewRowHeight
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let function = self.tableViewDisplay[indexPath] {
            return function(cell!)
        }
        
        return cell!
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let function = self.tableViewSelectAction[indexPath] {
            function()
        }
    }
 
}

extension MyViewController {
    
    fileprivate func setTableViewDisplay() {
        self.tableViewDisplay[IndexPath(row: 0, section: 1)] = setupQuit
        self.tableViewDisplay[IndexPath(row: 0, section: 0)] = setupClearCache
    }
    
    private func setupQuit(cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .red
        cell.textLabel?.text = "退出"
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    private func setupClearCache(cell: UITableViewCell) -> UITableViewCell {
        let x: CGFloat = 10
        let h: CGFloat = 40
        let w: CGFloat = (kScreenWidth - CGFloat(20)) / 2
        let y = (self.tableViewRowHeight - h) / 2
        let x2 = x + w
        let cacheTextLabel = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        cacheTextLabel.text = "清除缓存"

        self.cacheSizeLabel = UILabel(frame: CGRect(x: x2, y: y, width: w, height: h))
        self.cacheSizeLabel.textAlignment = NSTextAlignment.right
        
        self.cacheActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.cacheActivityIndicatorView.frame = cacheSizeLabel.frame
        self.cacheActivityIndicatorView.startAnimating()
        self.cacheSizeLabel.isHidden = true
        
        cell.addSubview(cacheTextLabel)
        cell.addSubview(cacheSizeLabel)
        cell.addSubview(cacheActivityIndicatorView)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        getCacheAndShowUI()
        
        return cell
    }
    
    private func getCacheSize(complete: @escaping (CGFloat) -> Void) {
        DispatchQueue.global().async {
            let fileManager = FileManager.default
            let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
            let directoryEnumerator = fileManager.enumerator(atPath: cache!)
            
            var total: CGFloat = 0
            
            while let path = directoryEnumerator?.nextObject() as? String {
                var isDir = ObjCBool(true)
                let full = cache?.appending("/\(path)")
                if fileManager.fileExists(atPath: full!, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        let nAttributes = try? fileManager.attributesOfItem(atPath: full!)
                        if let attributes = nAttributes {
                            let size = attributes[FileAttributeKey.size]
                            if let s = size {
                                total += s as! CGFloat
                            }
                        }
                    }
                }
            }
            complete(total)
        }
    }
    
    fileprivate func getCacheAndShowUI() {
        getCacheSize() { (size) in
            let sizeM = size / 1024 / 1024
            DispatchQueue.main.async {
                if sizeM >= 0 {
                    self.cacheActivityIndicatorView.isHidden = true
                    self.cacheActivityIndicatorView.stopAnimating()
                    self.cacheSizeLabel.text = "\(Int(sizeM)) M"
                    self.cacheSizeLabel.isHidden = false
                } else {
                    self.cacheActivityIndicatorView.isHidden = true
                    self.cacheActivityIndicatorView.stopAnimating()
                    self.cacheSizeLabel.text = "0 M"
                    self.cacheSizeLabel.isHidden = false
                }
            }
        }
    }
    
}

extension MyViewController {
    
    fileprivate func setTableViewSelectAction() {
        self.tableViewSelectAction[IndexPath(row: 0, section: 1)] = quit
        self.tableViewSelectAction[IndexPath(row: 0, section: 0)] = clearCache
    }
    
    private func clearCache() {
        let actionController = UIAlertController(title: "警告", message: "确认清除缓存？", preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "确认", style: .default){ (_) -> Void in
            
            self.cacheSizeLabel.isHidden = true
            self.cacheActivityIndicatorView.isHidden = false
            self.cacheActivityIndicatorView.startAnimating()
            
            DispatchQueue.global().async {
                let fileManager = FileManager.default
                let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
                let nSubPaths = fileManager.subpaths(atPath: cache!)
                if let subPaths = nSubPaths {
                    for subPath in subPaths {
                        let full = cache?.appending("/\(subPath)")
                        if fileManager.fileExists(atPath: full!) {
                            try? fileManager.removeItem(atPath: full!)
                            self.getCacheAndShowUI()
                        }
                    }
                }
            }
        }
        let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        actionController.addAction(actionCancel)
        actionController.addAction(actionConfirm)
        self.navigationController?.present(actionController, animated: true, completion: nil)
    }
    
    private func quit() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
