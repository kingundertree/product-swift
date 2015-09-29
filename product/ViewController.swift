//
//  ViewController.swift
//  product
//
//  Created by xiazer on 15/9/28.
//  Copyright © 2015年 com.freshfresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cv: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addTitle()
        addColletionView()
    }

    
    func addTitle () {
        navigationItem.title = "product-swift"
        view.backgroundColor = UIColor.redColor()
    }

    func addColletionView () {
        let layout = UICollectionViewFlowLayout()
        let margin:CGFloat = 10
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
        
        let itemH:CGFloat = 100
        let itemW:CGFloat = (ScreenWidth-3 * margin)/4
        
        layout.itemSize = CGSizeMake(itemW, itemH)
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 50)
        
        cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.colorWith(255, green: 255, blue: 255, alpha: 0.6)
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        cv.registerClass(ProductCell.self, forCellWithReuseIdentifier: "cell")
        cv.registerClass(ProductHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        view.addSubview(cv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK - UICollectionViewDelegate UICollectionViewDataSource 代理方法
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProductCell;
        cell.model = nil
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath) as! ProductHeaderView
        
        let model = ProductCellModel()
        model.indexNum = indexPath.row
        headerView.model = model
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = ProductDetailView()
        vc.showTitle("产品详情")
        navigationController?.pushViewController(vc, animated: true)
    }
}
