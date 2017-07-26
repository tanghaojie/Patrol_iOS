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
    
    var line1: UILabel!
    var line2: UILabel!
    var line3: UILabel!
//    var line4: UIView!
    //var line5: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(str1: String, str2: String?){

        line1.text = str1
        line2.text = str2
    }
    


    func setData(event: JSON_Event) {
        line1.text = "\(event.realname ?? "") 上报事件)"
        line2.text = "事件地址 \(event.address ?? "")"
        line3.text = "事件详情 \(event.remark ?? "")"
//        line5.text = "\(String(describing: event.actualtime))"
    }
    
    func setData(process: JSON_Process) {
        line1.text = "\(process.operatorname ?? "") \(process.statecode_alias ?? ""))"
        if process.statecode == "0001010400000002" {
            var names = ""
            for name in process.uids {
                names += "\(name.realname ?? "未知")、"
            }
            names = names.substring(to: names.index(names.endIndex, offsetBy: -1))
            line2.text = "分派人员 \(names)"
        }
    }


}

extension THJTableViewCell {
    
    fileprivate func setupUI() {
        
        self.backgroundColor = .gray
        
        setupLine1()
        setupLine2()
        setupLine3()
        
        setupConstraints()
    }
    
    private func setupLine1() {
        line1 = UILabel()
        line1.font = UIFont.boldSystemFont(ofSize: 18)
        line1.numberOfLines = 0
        
        line1.backgroundColor = .red
        self.addSubview(line1)
    }
    
    private func setupLine2() {
        line2 = UILabel()
        line2.font = UIFont.systemFont(ofSize: 16)
        line2.numberOfLines = 0
        
        line2.backgroundColor = .green
        self.addSubview(line2)
    }
    
    private func setupLine3() {
        line3 = UILabel()
        line3.font = UIFont.systemFont(ofSize: 16)
        line3.numberOfLines = 0
        
        line3.backgroundColor = .black
        self.addSubview(line3)
    }
    
    private func setupConstraints() {
        
        line1.snp.makeConstraints({(make) in
            make.top.equalTo(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        })
        
        line2.snp.remakeConstraints({(make) in
            make.top.equalTo(self.line1.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        })
        
        line3.snp.remakeConstraints({(make) in
            make.top.equalTo(self.line2.snp.bottom).offset(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-20)
        })
        
    }
    
    
   
    
}
