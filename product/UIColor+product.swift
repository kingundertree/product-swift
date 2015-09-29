//
//  UIColor+product.swift
//  product
//
//  Created by xiazer on 15/9/28.
//  Copyright © 2015年 com.freshfresh. All rights reserved.
//

import Foundation


// UIColor category
extension UIColor {
    class func colorWith(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        return color
    }
}
