//
//  TaskSBViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/6.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class TaskSBViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskType: UIButton!
    @IBOutlet weak var taskTypeTableView: UITableView!
    @IBOutlet weak var taskExplain: UITextView!
    @IBOutlet weak var taskStartLabel: UILabel!
    @IBOutlet weak var taskStart: UIButton!
    @IBOutlet weak var taskStop: UIButton!
    
    var isStartTask = false
    var pTaskName : String?
    var pTaskType : TaskType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTypeTableView.dataSource = self
        self.taskTypeTableView.delegate = self
        self.taskExplain.delegate = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if((loginUser?.config?.taskType.count)! > 0){
            let name = loginUser?.config?.taskType[0].alias
            setSelection(taskName: name!)
        }
    }

    private func setupUI(){
        setupScrollView()
        setupBackButton()
        setupTitle()
        self.taskStop.isHidden = true
        self.taskStartLabel.isHidden = true
    }

    private func setupScrollView(){
        scrollView.frame = self.view.frame
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        //scrollView.pagingEnabled = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        //scrollView.delegate = self
        scrollView.scrollsToTop = true
        scrollView.keyboardDismissMode = .onDrag
    }
    
    private func setupBackButton(){
        let leftBtn = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(backButtonAction))
        leftBtn.title = "返回";
        leftBtn.image = UIImage(named: "downward-1")
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    private func setupTitle(){
        self.navigationItem.title = "任务"
    }
    
    func backButtonAction(){
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }

    @IBAction func taskTypeBtnTouchUpInSide(_ sender: Any) {
        switchTable()
    }
    
    @IBAction func startTaskTouchUpInSide(_ sender: Any) {
    }
    
    @IBAction func stopTaskTouchUpInSide(_ sender: Any) {
    }

}

extension TaskSBViewController: UITableViewDataSource , UITableViewDelegate{
    
    func switchTable(){
        if(self.taskTypeTableView.isHidden){
            self.view.bringSubview(toFront: taskTypeTableView)
            UIView.animate(withDuration: 0.5, animations: {
                self.taskTypeTableView?.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.taskTypeTableView?.isHidden = true
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (loginUser?.config?.taskType.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil  {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellid")
        }
        cell?.backgroundColor = UIColor(red: 225, green: 225, blue: 225)
        let item = loginUser?.config?.taskType[indexPath.row]
        cell?.textLabel?.text = item?.alias
        cell?.textLabel?.textAlignment = .center
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = loginUser?.config?.taskType[indexPath.row]
        self.pTaskType = item
        self.taskType.setTitle((item?.alias)!, for: .normal)
        switchTable()
    }
    
    func setSelection(taskName : String){
        let index = loginUser?.config?.taskType.index(where: { (iTType) -> Bool in
            return iTType.alias == taskName
        })
        if let iindex = index{
            tableView(self.taskTypeTableView, didSelectRowAt: IndexPath.init(row: iindex, section: iindex))
        }
    }
}

extension TaskSBViewController: UITextViewDelegate  {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(!self.taskTypeTableView.isHidden){
            switchTable()
        }
    }
}


