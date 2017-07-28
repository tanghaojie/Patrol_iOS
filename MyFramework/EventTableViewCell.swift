//
//  EventTableViewCell.swift
//  MyFramework
//
//  Created by JT on 2017/7/24.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let cellHeight = 180
    fileprivate let margin_Horizontal: CGFloat = 10
    fileprivate let margin_Vertical: CGFloat = 20
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: JSON_Event) {
        self.data = data
        setDataToUI()
    }
    
    private func setDataToUI() {
        titleLabel.text = self.data.eventname
        bottomLabel.text = self.data.statecode_alias
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
        setupItemView()
        //setupBorder()
        
        setupTitle()
        setupBottom()
        setupMain()
    }
    
    private func setupItemView() {
        let w = kScreenWidth //- margin_Horizontal * 2
        let h = CGFloat(EventTableViewCell.cellHeight) - margin_Vertical * 2
        itemView = UIView(frame: CGRect(x: 0, y: margin_Vertical, width: w, height: h))
        itemView.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        self.contentView.addSubview(itemView)
    }
    
    private func setupBorder() {
        itemView.layer.borderWidth = 1
        itemView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setupTitle() {
        let w = itemView.frame.width - margin_Content * 2
        let h:CGFloat = 21
        titleLabel = UILabel(frame: CGRect(x: margin_Content, y: margin_Content, width: w, height: h))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        itemView.addSubview(titleLabel)
    }
    
    private func setupMain() {
        setupMainView()
        setupMainTop()
        setupMainText()
    }
    
    private func setupMainView() {
        let w = itemView.frame.width - margin_Content * 2
        let h:CGFloat = itemView.frame.height - margin_Content * 2 - margin_inner * 2 - titleLabel.frame.height - bottomLabel.frame.height
        let y = margin_Content + margin_inner + titleLabel.frame.height
        mainView = UIView(frame: CGRect(x: margin_Content, y: y, width: w, height: h))

        itemView.addSubview(mainView)
    }
    
    private func setupMainTop() {
        let w = mainView.frame.width / 3
        let h:CGFloat = mainView_topHeight
        mainViewTopLeft = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        mainView.addSubview(mainViewTopLeft)
        mainViewTopLeftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        mainViewTopLeftLabel.font = UIFont.systemFont(ofSize: 16)
        mainViewTopLeft.addSubview(mainViewTopLeftLabel)

        mainViewTopRight = UIView(frame: CGRect(x: w, y: 0, width: w, height: h))
        mainView.addSubview(mainViewTopRight)
        mainViewTopRightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        mainViewTopRightLabel.font = UIFont.systemFont(ofSize: 16)
        mainViewTopRight.addSubview(mainViewTopRightLabel)
    }
    
    private func setupMainText() {
        let w = mainView.frame.width
        let y = mainView_topHeight + 3
        let h = mainView.frame.height - y
        mainViewTextView = UITextView(frame: CGRect(x: 0, y: y, width: w, height: h))
        mainViewTextView.isEditable = false
        mainViewTextView.isScrollEnabled = false
        mainViewTextView.isUserInteractionEnabled = false
        mainViewTextView.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        mainViewTextView.textContainer.lineFragmentPadding = 0
        mainViewTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainViewTextView.font = UIFont.systemFont(ofSize: 16)
        mainView.addSubview(mainViewTextView)
    }
    
    private func setupBottom() {
        setupBottomView()
        setupBottomLabel()
        setupBottomDateLabel()
    }
    
    private func setupBottomView() {
        let w = itemView.frame.width - margin_Content * 2
        let h:CGFloat = 18
        bottomView = UIView(frame: CGRect(x: margin_Content, y: itemView.frame.height - margin_Content - h, width: w, height: h))
        itemView.addSubview(bottomView)
    }
    
    private func setupBottomLabel() {
        let w = bottomView.frame.width / 2
        let h = bottomView.frame.height
        bottomLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h))
        bottomLabel.font = UIFont.systemFont(ofSize: 18)
        bottomView.addSubview(bottomLabel)
    }
    
    private func setupBottomDateLabel() {
        let w: CGFloat = 160
        let x = bottomView.frame.width - w
        let h = bottomView.frame.height
        bootomDateLabel = UILabel(frame: CGRect(x: x, y: 0, width: w, height: h))
        bootomDateLabel.font = UIFont.systemFont(ofSize: 16)
        bottomView.addSubview(bootomDateLabel)
    }
    
}