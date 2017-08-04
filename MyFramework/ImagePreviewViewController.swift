//
//  ImagePreviewViewController.swift
//  MyFramework
//
//  Created by JT on 2017/8/3.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    var images: [UIImage]
    var index: Int
    var collectionView: UICollectionView!
    var pageControl: UIPageControl!
    
    init(images: [UIImage], index: Int = 0){
        self.images = images
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.view.bounds.size
        layout.scrollDirection = .horizontal
        self.automaticallyAdjustsScrollViewInsets = false
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(ImagePreviewCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        self.view.addSubview(collectionView)

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)

        pageControl = UIPageControl()
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
        pageControl.numberOfPages = images.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index
        view.addSubview(self.pageControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}

extension ImagePreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! ImagePreviewCollectionViewCell
            let image = self.images[indexPath.row]
            cell.imageView.image = image
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImagePreviewCollectionViewCell{
            cell.resetSize()
            self.pageControl.currentPage = indexPath.item
        }
    }
}
