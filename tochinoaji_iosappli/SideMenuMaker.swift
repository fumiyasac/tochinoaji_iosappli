//
//  SideMenuMaker.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/15.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

enum LinkStatus: String {
    case internalLink = "internal"
    case safariLink = "safari"
}

struct SideMenuMaker {
    
    static func makeMenuList() -> [[String]] {
        
        /**
         * サイドメニュー部分は決め打ちになるので下記のように定義
         * 0番目 → メニューのラベル文言
         * 1番目 → メニューのセル文言
         * 2番目 → リンクの種類
         * 3番目 → リンク先情報
         */
        return [
            [
                "ラベル部分1",
                "サイドメニュー名1",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分2",
                "サイドメニュー名2",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分3",
                "サイドメニュー名3",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分4",
                "サイドメニュー名4",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分5",
                "サイドメニュー名5",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分6",
                "サイドメニュー名6",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分7",
                "サイドメニュー名7",
                LinkStatus.internalLink.rawValue,
                ""
            ],
            [
                "ラベル部分8",
                "サイドメニュー名8",
                LinkStatus.internalLink.rawValue,
                ""
            ]

        ]

    }

}