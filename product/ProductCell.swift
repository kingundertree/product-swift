//
//  ProductCell.swift
//  product
//
//  Created by xiazer on 15/9/29.
//  Copyright © 2015年 com.freshfresh. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    var model:ProductCellModel? {
        didSet {
            let imgV = UIImageView(frame: CGRectMake(0, 0, 60, 60))
            imgV.backgroundColor = UIColor.blackColor()
            imgV.showImageWith("http://media.freshfresh.com/media/wysiwyg/1920-500/285-197-HuiLi.jpg")
            self.addSubview(imgV)
            
            let lab = UILabel(frame: CGRectMake(0, 60, 60, 30))
            lab.text = "你好"
            lab.textColor = UIColor.blackColor()
            self.addSubview(lab)
        }
    }
}
