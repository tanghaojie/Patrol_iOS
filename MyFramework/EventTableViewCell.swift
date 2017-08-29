//
//  EventTableViewCell.swift
//  MyFramework
//
//  Created by JT on 2017/7/24.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let cellHeight = 160
    fileprivate let margin_Horizontal: CGFloat = 15
    fileprivate let margin_Vertical: CGFloat = 18
    fileprivate let margin_Content: CGFloat = 10
    fileprivate let mainView_topHeight: CGFloat = 18
    fileprivate let margin_inner: CGFloat = 5
    
    fileprivate var itemView: UIView!
    fileprivate var titleLabel: UILabel!
    fileprivate var bottomView: UIView!
    fileprivate var bottomLabel: UILabel!
    fileprivate var bootomDateLabel: UILabel!
    fileprivate var mainView: UIView!
    fileprivate var mainViewTopLeft: UIView!
    fileprivate var mainViewTopLeftLabel: UILabel!
    fileprivate var mainViewTopRight: UIView!
    fileprivate var mainViewTopRightLabel: UILabel!
    fileprivate var mainViewTextView: UITextView!

    var data: JSON_Event!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    deinit {
        print("--release EventTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: JSON_Event) {
        self.data = data
        setDataToUI()
    }
    
    private func setDataToUI() {
        titleLabel.text = self.data.eventname
        let stateCodeAlias = self.data.statecode_alias
        bottomLabel.text = stateCodeAlias
        if stateCodeAlias == "处理中" {
            bottomLabel.textColor = .red
        } else {
            bottomLabel.textColor = UIColor(red: 155, green: 155, blue: 155)
        }
        mainViewTopLeftLabel.text = self.data.typecode_alias
        mainViewTopRightLabel.text = self.data.levelcode_alias
        if let remark = self.data.remark {
            mainViewTextView.text = remark
        }
        if let date = self.data.actualtime {
            bootomDateLabel.text = getDateFormatter(dateFormatter: kDateTimeFormate).string(from: date)
        }
    }

}

extension EventTableViewCell {
    
    fileprivate func setupUI() {
        self.backgroundColor = UIColor(red: 237, green: 238, blue: 240)
        
        setupItemView()
        //setupBorder()
        
        setupTitle()
        setupBottom()
        setupMain()
    }
    
    private func setupItemView() {
        let w = kScreenWidth
        let h = CGFloat(EventTableViewCell.cellHeight) - margin_Vertical
        itemView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        itemView.backgroundColor = UIColor(red: 255, green: 255, blue: 255)
        self.contentView.addSubview(itemView)
    }
    
    private func setupBorder() {
        itemView.layer.borderWidth = 1
        itemView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setupTitle() {
        let w = itemView.frame.width - margin_Content * 2
        let h: CGFloat = 24
        titleLabel = UILabel(frame: CGRect(x: margin_Content, y: margin_Content, width: w, height: h))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 64, green: 64, blue: 64)
        itemView.addSubview(titleLabel)
    }
    
    private func setupMain() {
        setupMainView()
        setupMainTop()
        setupMainText()
    }
    
    private func setupMainView() {
        let w = itemView.frame.width - margin_Content * 2
        let h: CGFloat = itemView.frame.height - margin_Content * 2 - margin_inner * 2 - titleLabel.frame.height - bottomView.frame.height
        let y = margin_Content + margin_inner + titleLabel.frame.height
        mainView = UIView(frame: CGRect(x: margin_Content, y: y, width: w, height: h))
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: w, height: 1)
        layer.backgroundColor = UIColor(red: 215, green: 215, blue: 215).cgColor
        mainView.layer.addSublayer(layer)
        
        let blayer = CALayer()
        blayer.frame = CGRect(x: 0, y: h, width: w, height: 1)
        blayer.backgroundColor = UIColor(red: 215, green: 215, blue: 215).cgColor
        mainView.layer.addSublayer(blayer)

        itemView.addSubview(mainView)
    }
    
    private func setupMainTop() {
        let w = mainView.frame.width / 3
        let h:CGFloat = mainView_topHeight
        mainViewTopLeft = UIView(frame: CGRect(x: 0, y: margin_inner, width: w, height: h))
        mainView.addSubview(mainViewTopLeft)
        mainViewTopLeftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        mainViewTopLeftLabel.font = UIFont.systemFont(ofSize: 16)
        mainViewTopLeftLabel.textColor = UIColor(red: 155, green: 155, blue: 155)
        mainViewTopLeft.addSubview(mainViewTopLeftLabel)

        mainViewTopRight = UIView(frame: CGRect(x: w , y: margin_inner, width: w, height: h))
        mainView.addSubview(mainViewTopRight)
        mainViewTopRightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        mainViewTopRightLabel.font = UIFont.systemFont(ofSize: 16)
        mainViewTopRightLabel.textColor = UIColor(red: 155, green: 155, blue: 155)
        mainViewTopRight.addSubview(mainViewTopRightLabel)
    }
    
    private func setupMainText() {
        let w = mainView.frame.width
        let y = margin_inner + mainView_topHeight + margin_inner
        let h = mainView.frame.height - y
        mainViewTextView = UITextView(frame: CGRect(x: 0, y: y, width: w, height: h))
        mainViewTextView.isEditable = false
        mainViewTextView.isScrollEnabled = false
        mainViewTextView.isUserInteractionEnabled = false
        //mainViewTextView.backgroundColor = UIColor(red: 255, green: 255, blue: 255)
        mainViewTextView.textContainer.lineFragmentPadding = 0
        mainViewTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainViewTextView.font = UIFont.systemFont(ofSize: 16)
        mainViewTextView.textColor = UIColor(red: 84, green: 84, blue: 84)
        mainView.addSubview(mainViewTextView)
    }
    
    private func setupBottom() {
        setupBottomView()
        setupBottomLabel()
        setupBottomDateLabel()
    }
    
    private func setupBottomView() {
        let w = itemView.frame.width - margin_Content * 2
        let h: CGFloat = 20
        bottomView = UIView(frame: CGRect(x: margin_Content, y: itemView.frame.height - margin_Content - h, width: w, height: h))
        itemView.addSubview(bottomView)
    }
    
    private func setupBottomLabel() {
        let w = bottomView.frame.width / 2
        let h = bottomView.frame.height
        bottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        bottomLabel.font = UIFont.systemFont(ofSize: 16)
        bottomLabel.textColor = UIColor(red: 155, green: 155, blue: 155)
        bottomView.addSubview(bottomLabel)
    }
    
    private func setupBottomDateLabel() {
        let w: CGFloat = 160
        let x = bottomView.frame.width - w
        let h = bottomView.frame.height
        bootomDateLabel = UILabel(frame: CGRect(x: x, y: 0, width: w, height: h))
        bootomDateLabel.font = UIFont.systemFont(ofSize: 14)
        bootomDateLabel.textColor = UIColor(red: 155, green: 155, blue: 155)
        bottomView.addSubview(bootomDateLabel)
    }
    
}
