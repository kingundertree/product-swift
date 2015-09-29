//
//  ProductHeaderView.swift
//  product
//
//  Created by xiazer on 15/9/29.
//  Copyright © 2015年 com.freshfresh. All rights reserved.
//

import UIKit

class ProductHeaderView: UICollectionReusableView {

    var model:ProductCellModel! {
        didSet {
            self.backgroundColor = UIColor.blackColor()
            let lab = UILabel(frame: CGRectMake(0, 0, ScreenWidth, 50))
            let indexN: NSInteger = model.indexNum!
            let title: NSString = NSString(format: "index==>%ld",indexN)
            lab.text = title as String
            lab.textAlignment = NSTextAlignment.Center
            lab.textColor = UIColor.whiteColor()
//            lab.text = "title"
            self.addSubview(lab)
        }
    }
    
    
}
