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
    fileprivate var headPotraitImageView: UIImageView!
    
    fileprivate var tableViewDisplay = Dictionary<IndexPath,(UITableViewCell) -> UITableViewCell>()
    fileprivate var tableViewSelectAction = Dictionary<IndexPath,() -> Void>()
    
    fileprivate let tableViewHeaderHeight: CGFloat = 200
    fileprivate let tableViewHeaderImageWH: CGFloat = 180
    fileprivate let tableViewRowHeight: CGFloat = 40

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
        headView.backgroundColor = .white
        
        self.headPotraitImageView = UIImageView(frame: CGRect(x: (kScreenWidth - tableViewHeaderImageWH) / 2, y: (tableViewHeaderHeight - tableViewHeaderImageWH) / 2, width: tableViewHeaderImageWH, height: tableViewHeaderImageWH))
        self.headPotraitImageView.contentMode = .scaleAspectFill
        self.headPotraitImageView.layer.masksToBounds = true
        self.headPotraitImageView.layer.cornerRadius = tableViewHeaderImageWH / 2
        self.headPotraitImageView.layer.borderWidth = 2
        self.headPotraitImageView.layer.borderColor = UIColor.gray.cgColor
        self.headPotraitImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(headPotraitAction))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.headPotraitImageView.addGestureRecognizer(tapGestureRecognizer)

        headView.addSubview(self.headPotraitImageView)
        
        HeadPortrait(imageView: self.headPotraitImageView)
//        let line = CALayer()
//        line.frame = CGRect(x: 0, y: tableViewHeaderHeight - 1, width: headView.frame.width, height: 5)
//        line.backgroundColor = UIColor(red: 255, green: 255, blue: 255).cgColor
//        headView.layer.addSublayer(line)
        
        return headView
    }
    
    internal func headPotraitAction() {
        addImageAction()
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
        let wid : CGFloat = 75.0
        let hei : CGFloat = 44.0
        let x : CGFloat = 22.5
        let y : CGFloat = 0
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: x, y: y, width: wid, height: hei)
        titleLabel.text = "我的"
        titleLabel.textAlignment = .center
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

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
        cell.backgroundColor = UIColor(red: 247, green: 33, blue: 0)
        cell.textLabel?.text = "退出"
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = .white
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    private func setupClearCache(cell: UITableViewCell) -> UITableViewCell {
        let x: CGFloat = 20
        let h: CGFloat = 40
        let w: CGFloat = (kScreenWidth - CGFloat(x * 2)) / 2
        let y = (self.tableViewRowHeight - h) / 2
        let x2 = x + w
        let cacheTextLabel = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        cacheTextLabel.text = "清除缓存"
        cacheTextLabel.textColor = UIColor(red: 64, green: 64, blue: 64)

        self.cacheSizeLabel = UILabel(frame: CGRect(x: x2, y: y, width: w, height: h))
        self.cacheSizeLabel.textColor = UIColor(red: 113, green: 122, blue: 132)
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

extension MyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        let date = getDateFormatter(dateFormatter: "yyyy-MM-dd+HH:mm:ss").string(from: Date().addingTimeInterval(kTimeInteval))
        let compressedImage = Image.instance.compressImage(originalImg: image, resolution: 300)
        if let cImg = compressedImage {
            Image.instance.uploadImages(images: [cImg], prid: "\(loginInfo?.userId ?? 1)", typenum: "0", actualtime: date){ (prid) in
                self.HeadPortrait(imageView: self.headPotraitImageView)
            }
        } else {
            AlertWithUIAlertAction(view: self, title: msg_UploadFailed, message: "", preferredStyle: UIAlertControllerStyle.alert, uiAlertAction: UIAlertAction(title: msg_OK, style: .default, handler: nil))
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
