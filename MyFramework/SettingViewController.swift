//
//  SettingViewController.swift
//  MyFramework
//
//  Created by JT on 2017/8/7.
//  Copyright © 2017年 JT. All rights reservar.
//

import UIKit
import SwiftyJSON

class SettingViewController: UIViewController {
    
    static let settingFileName = "setting.txt"

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var serviceAddress: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = self.view.frame
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.scrollsToTop = true
        scrollView.keyboardDismissMode = .onDrag
        self.serviceAddress.text = url_Main
    }
    
    @IBAction func confirmTouchUpInSide(_ sender: Any) {
        let ns = self.serviceAddress.text
        if ns == nil || ns!.isEmpty {
            AlertWithNoButton(view: self, title: msg_Error, message: msg_PleaseEnterServiceAddress, preferredStyle: UIAlertControllerStyle.alert, showTime: 1)
            return
        } else {
            let address = ns!
            if !checkServiceAddress(address: address) {
                AlertWithNoButton(view: self, title: msg_Error, message: msg_NetworkOrAddressError, preferredStyle: UIAlertControllerStyle.alert, showTime: 1)
                return
            }
            url_Main = address
            setServiceInfoToFile(serviceInfo: address)
            back()
        }
    }
    
    private func checkServiceAddress(address: String) -> Bool {
        var urlRequest = URLRequest(url: URL(string: "\(address)/test.json")!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Get.rawValue
        urlRequest.httpShouldHandleCookies = true
        var response : URLResponse?
        let data = try? NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
        if data == nil || data!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    @IBAction func backTouchUpInSide(_ sender: Any) {
        back()
    }
    
    private func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setServiceInfoToFile(serviceInfo: String) {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let settingUrl = docPath?.appending("/\(SettingViewController.settingFileName)")
        writeText(fileUrl: URL.init(string: settingUrl!)!, str: serviceInfo)
    }
    
    static func getServiceInfoFromFile() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let settingUrl = docPath?.appending("/\(SettingViewController.settingFileName)")
        
        let nS = readText(fileUrl: URL.init(string: settingUrl!)!)
        if let s = nS {
            url_Main = s
        } else {
            url_Main = ""
        }
    }

}