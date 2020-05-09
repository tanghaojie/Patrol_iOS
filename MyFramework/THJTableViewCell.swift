//
//  THJTableViewCell.swift
//  MyFramework
//
//  Created by JT on 2017/7/25.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit
import SnapKit

class THJTableViewCell: UITableViewCell {
    
    var navigationController: UINavigationController?
    
    var line1: UILabel!
    var line2: UILabel!
    var line3: UILabel!
    var imageViewContainer: UIView!
    var line5: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    deinit {
        print("--release THJTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(event: JSON_Event, navigationController: UINavigationController?) {
        line1.text = "\(event.realname ?? "") 上报事件 \(event.eventname ?? "")"
        var eAddress = ""
        if event.address == nil || (event.address?.isEmpty)! {
            eAddress = "无"
        } else {
            eAddress = event.address!
        }
        line2.text = "事件地址 \(eAddress)"
        line3.text = event.remark
        setupImages(imageCount: event.picturecount, prid: event.id, typenum: 1)
        if let date = event.actualtime {
            line5.text = "\(getDateFormatter(dateFormatter: kDateTimeFormate).string(from: date))"
        }
        
        self.navigationController = navigationController
    }
    
    func setData(process: JSON_Process, navigationController: UINavigationController?) {
        line1.text = "\(process.operatorname ?? "") \(process.statecode_alias ?? "")"
        if process.statecode == "0001010400000002" {
            var names = ""
            for name in process.uids {
                names += "\(name.realname ?? "未知")、"
            }
            names = names.substring(to: names.index(names.endIndex, offsetBy: -1))
            line2.text = "处理人员 \(names)"
        } else {
            line2.text = nil
        }
        line3.text = process.remark
        
        setupImages(imageCount: process.picturecount, prid: process.id, typenum: 2)
        
        if let date = process.actualtime {
            line5.text = "\(getDateFormatter(dateFormatter: kDateTimeFormate).string(from: date))"
        }
        
        self.navigationController = navigationController
    }

}

extension THJTableViewCell {
    
    fileprivate func setupUI() {
        
        self.backgroundColor = .white
        
        setupLine1()
        setupLine2()
        setupLine3()
        setupLine4()
        setupLine5()
        
        setupConstraints()
    }
    
    private func setupLine1() {
        line1 = UILabel()
        line1.font = UIFont.boldSystemFont(ofSize: 20)
        line1.textColor = UIColor(red: 64, green: 64, blue: 64)
        line1.numberOfLines = 0
        
        //line1.backgroundColor = .red
        self.addSubview(line1)
    }
    
    private func setupLine2() {
        line2 = UILabel()
        line2.font = UIFont.systemFont(ofSize: 16)
        line2.textColor = UIColor(red: 84, green: 84, blue: 84)
        line2.numberOfLines = 0
        
        //line2.backgroundColor = .green
        self.addSubview(line2)
    }
    
    private func setupLine3() {
        line3 = UILabel()
        line3.font = UIFont.systemFont(ofSize: 16)
        line3.textColor = UIColor(red: 84, green: 84, blue: 84)
        line3.numberOfLines = 0
        
        //line3.backgroundColor = .yellow
        self.addSubview(line3)
    }
    
    private func setupLine4() {
        imageViewContainer = UIView()
        
        //line4.backgroundColor = .darkGray
        self.addSubview(imageViewContainer)
    }
    
    private func setupLine5() {
        line5 = UILabel()
        line5.font = UIFont.systemFont(ofSize: 16)
        line5.textColor = UIColor(red: 155, green: 155, blue: 155)
        line5.numberOfLines = 0
        
        //line5.backgroundColor = .blue
        self.addSubview(line5)
    }
    
    private func setupConstraints() {
        
        line1.snp.makeConstraints({(make) in
            make.top.equalTo(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        })
        
        line2.snp.makeConstraints({ [weak self] (make) in
            if self == nil { return }
            make.top.equalTo(self!.line1.snp.bottom).offset(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        })
        
        line3.snp.makeConstraints({ [weak self] (make) in
            if self == nil { return }
            make.top.equalTo(self!.line2.snp.bottom).offset(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        })
        
        imageViewContainer.snp.makeConstraints({ [weak self] (make) in
            if self == nil { return }
            make.top.equalTo(self!.line3.snp.bottom).offset(4)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(4)
        })
        
        line5.snp.makeConstraints({ [weak self] (make) in
            if self == nil { return }
            make.top.equalTo(self!.imageViewContainer.snp.bottom).offset(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-20)
        })
    }
    
    fileprivate func setupImages(imageCount: Int, prid: Int, typenum: Int) {
        if imageCount > 0 && imageViewContainer.subviews.count < imageCount {
            imageViewContainer.snp.updateConstraints({ (make) in
                let h = ceil(Double(imageCount) / 3.0) * 85
                make.height.equalTo(h)
            })

            for index in 0..<imageCount {
                let x = (index % 3) * 85
                let y = (index / 3) * 85
                let imgView = UIImageView(frame: CGRect(x: Double(x) + 2.5, y: Double(y) + 2.5, width: 80, height: 80))
                imgView.contentMode = .scaleAspectFill
                imgView.clipsToBounds = true
                imgView.tag = index
                self.imageViewContainer.addSubview(imgView)
            }
            
            Image.instance.getImages(prid: prid, typenum: typenum, useCache: true) { [weak self] (uiimage, index) in
                if index < imageCount {
                    if let imgView = self?.imageViewContainer.subviews[index] as? UIImageView {
                        if imgView.tag == index {
                            DispatchQueue.main.async {
                                imgView.image = uiimage
                            }
                        }
                    }
                }
            }

            let tap = UITapGestureRecognizer(target:self, action:#selector(imageViewTap(_:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imageViewContainer.addGestureRecognizer(tap)
        } else if imageCount <= 0 {
            // do not delete the code after 'else if' , it's magic
            for view in imageViewContainer.subviews {
                view.removeFromSuperview()
            }
            imageViewContainer.snp.updateConstraints({ (make) in
                make.height.equalTo(4)
            })
        }
    }
    
    @objc func imageViewTap(_ recognizer: UITapGestureRecognizer){
        
        var imgs = [UIImage]()
        for subView in imageViewContainer.subviews {
            let imgView = subView as? UIImageView
            if let imgV = imgView {
                if let img = imgV.image {
                    imgs.append(img)
                }
            }
        }
        
        if imgs.count > 0 {
            let previewVC = ImagePreviewViewController(images: imgs)
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }

}
