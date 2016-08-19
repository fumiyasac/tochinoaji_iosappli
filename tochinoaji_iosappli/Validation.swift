//
//  Validation.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/17.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct Validation {
    
    //文字列の存在チェック
    static func checkExistenceString(checkString: String) -> Bool {
        
        if checkString.isEmpty {
            return false
        } else {
            return true
        }
        
    }
    
    //数字チェック
    static func checkNumeric(checkString: String) -> Bool {
        
        let targetNumeric: Int? = Int(checkString)
        
        if targetNumeric != nil {
            return true
        } else {
            return false
        }
        
    }
    
}
