//
//  EventImage.swift
//  MyFramework
//
//  Created by JT on 2017/7/19.
//  Copyright © 2017年 JT. All rights reserved.
//
import SwiftyJSON
class Image {
    
    static let instance = Image()
    private let boundary = "----------xJackieTang"
    //var eventDelegate: EventDelegate? = nil
    
    private init() {}

    func saveImages(path: String, images: [UIImage], compressFunc: (UIImage) -> UIImage?){
        for image in images {
            let nCompressedImg = compressFunc(image)
            if let compressedImg = nCompressedImg {
                let nDataImage = UIImageJPEGRepresentation(compressedImg, 1.0)
                if let dataImage = nDataImage {
                    let date = Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
                    let dateStr = getDateFormatter(dateFormatter: "yyyyMMddHHmmss").string(from: date)
                    var isDir = ObjCBool(true)
                    if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
                        do{
                            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                    let url = URL(fileURLWithPath: "\(path)/\(dateStr)\(Int(arc4random()%100)).jpg")
                    do{
                        try dataImage.write(to: url, options: Data.WritingOptions.atomic)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func wechatCompressImage(originalImg:UIImage) -> UIImage? {
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        var sizeChange = CGSize()

        if width <= 1280 && height <= 1280{
            return originalImg
        }else {
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if scale >= 0.5 && scale <= 1 {
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if width > 1280 && height > 1280 {
                if scale > 2 {
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }else if scale < 0.5{
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }
            }else {
                return originalImg
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImg
    }
    
    func wechatCompressImage_720(originalImg:UIImage) -> UIImage? {
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        var sizeChange = CGSize()
        
        if width <= 720 && height <= 720{
            return originalImg
        }else {
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 720
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if scale >= 0.5 && scale <= 1 {
                let changedheight:CGFloat = 720
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }else if width > 1280 && height > 720 {
                if scale > 2 {
                    let changedheight:CGFloat = 720
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }else if scale < 0.5{
                    let changedWidth:CGFloat = 720
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }
            }else {
                return originalImg
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImg
    }
    
    func uploadImages(images: [UIImage], prid: String, typenum: String, actualtime: String, eventImagesUploadComplete: ((_ eventId: Int) -> Void)?) {
        var urlRequest = URLRequest(url: URL(string: getUploadImage(prid: prid, typenum: typenum, actualtime: actualtime))!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        for image in images {
            let sBody = setImageInfo(image: image)
            body.append(sBody)
        }
        body.append("--\(boundary)--".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        let len = String(body.count)
        urlRequest.setValue(len, forHTTPHeaderField: "Content-Length")
        urlRequest.httpBody = body
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: OperationQueue.main) {(response : URLResponse?, data : Data?, error : Error?) -> Void in
            if error != nil {
                return
            }
            if (data?.isEmpty)! {
                return
            }
            if let urlResponse = response {
                let httpResponse = urlResponse as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode != 200 {
                    return
                }
                let json = JSON(data : data!)
                let nStatus = json["status"].int
                if let status = nStatus {
                    if status != 0 {
                        return
                    }
                    print("upload images success")
                    if eventImagesUploadComplete != nil {
                        eventImagesUploadComplete?(Int(prid)!)
                    }
                }
            }
        }
    }
    
    func setImageInfo(image: UIImage) -> Data {
        var body = Data()
        let data: Data
        let format: String
        if UIImageJPEGRepresentation(image, 1.0) != nil {
            data = UIImageJPEGRepresentation(image, 1.0)!
            format = "Content-Type: image/jpeg\r\n"
        } else {
            data = UIImagePNGRepresentation(image)!
            format = "Content-Type: image/png\r\n"
        }
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"fieldNameHere\"; filename=\"\(CFUUIDCreateString(nil, CFUUIDCreate(nil))!).jpg\"\r\n".data(using: .utf8)!)
        body.append(format.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func getImageInfo(prid: Int, typenum: Int, complete: ((UIImage,Int) -> Void)?) {
        var urlRequest = URLRequest(url: URL(string: url_QueryImage)!)
        urlRequest.timeoutInterval = TimeInterval(kShortTimeoutInterval)
        urlRequest.httpMethod = HttpMethod.Post.rawValue
        var jsonDic = Dictionary<String,Any>()
        jsonDic["prid"] = prid
        jsonDic["typenum"] = typenum
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            urlRequest.httpShouldHandleCookies = true
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }catch {
            printLog(message: "Create event. json data wrong\(error)")
            return
        }
        URLSession.shared.dataTask(with: urlRequest){(data1, response, error) in
            if error != nil {
                return
            }
            if data1 == nil || (data1?.isEmpty)!{
                return
            }
            let json = JSON(data : data1!)
            if json == JSON.null {
                return
            }
            let data = json["data"]
            if data == JSON.null {
                return
            }
            let count = data.count
            for index in 0..<count {
                let item = data[index]
                if item == JSON.null {
                    continue
                }
                let name = item["path"].string
                if name == nil || (name?.isEmpty)! {
                    continue
                }
                let urlStr = "\(url_Picture)?typenum=\(typenum)&prid=\(prid)&filename=\(name!)"
                let url = URL(string: urlStr)
                let data = try? Data(contentsOf: url!)
                if data == nil || (data?.isEmpty)! {
                    continue
                }
                let img = UIImage(data: data!)
                if let i = img {
                    if let com = complete {
                        com(i, index)
                    }
                }
            }
        }.resume()
    }
    
}
