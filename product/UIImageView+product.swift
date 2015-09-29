//
//  UIImageView+product.swift
//  product
//
//  Created by xiazer on 15/9/29.
//  Copyright © 2015年 com.freshfresh. All rights reserved.
//

import Foundation


extension UIImageView {
    func showImageWith(url: NSString) {
        self.sd_setImageWithURL(NSURL(string: url as String), placeholderImage: nil)
    }
}