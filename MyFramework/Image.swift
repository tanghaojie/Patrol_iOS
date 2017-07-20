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

    
    
    
}
