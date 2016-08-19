//
//  ColorConverter.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/08.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct ColorConverter {
    
    //16進数のカラーコードをiOSの設定に変換するメソッド
    static func colorWithHexString (hex:String) -> UIColor {
        
        //受け取った値を大文字に変換する
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        //#があれば取り除く
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.grayColor()
        }
        
        //各々のコード部分を抜き出して変換を行う
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}
