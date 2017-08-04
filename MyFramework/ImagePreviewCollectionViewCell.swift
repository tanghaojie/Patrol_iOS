//
//  ImagePreviewCollectionViewCell.swift
//  MyFramework
//
//  Created by JT on 2017/8/3.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class ImagePreviewCollectionViewCell: UICollectionViewCell {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self

        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        imageView = UIImageView()
        imageView.frame = scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        let tapSingle=UITapGestureRecognizer(target:self,
                                             action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        let tapDouble=UITapGestureRecognizer(target:self,
                                             action:#selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    func resetSize(){
        scrollView.zoomScale = 1.0
        if let image = self.imageView.image {
            imageView.frame.size = scaleSize(size: image.size)
            imageView.center = scrollView.center
        }
    }
    
    func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/UIScreen.main.bounds.width
        let heightRatio = height/UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
    func tapSingleDid(_ ges:UITapGestureRecognizer){
        if let nav = self.responderViewController()?.navigationController{
            nav.setNavigationBarHidden(!nav.isNavigationBarHidden, animated: true)
        }
    }
    
    func tapDoubleDid(_ ges:UITapGestureRecognizer){
        if let nav = self.responderViewController()?.navigationController{
            nav.setNavigationBarHidden(true, animated: true)
        }
        UIView.animate(withDuration: 0.5, animations: {
            if self.scrollView.zoomScale == 1.0 {
                self.scrollView.zoomScale = 3.0
            }else{
                self.scrollView.zoomScale = 1.0
            }
        })
    }
    
    func responderViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
  
}

extension ImagePreviewCollectionViewCell: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
