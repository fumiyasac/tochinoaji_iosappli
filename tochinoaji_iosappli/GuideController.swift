//
//  GuideController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/15.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct GuideSetting {
    static let pageHeaderList: [String] = [
        "アプリのコンセプト",
        "活用法その1(未定)",
        "活用法その2(未定)",
        "活用法その3(未定)",
        "お問い合わせ等について"
    ]
}

class GuideController: UIViewController {

    @IBOutlet weak var guideContentsTableView: UITableView!

    private let sectionCount = 1
    private let cellCount = GuideSetting.pageHeaderList.count

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guideContentsTableView.delegate = self
        guideContentsTableView.dataSource = self

        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "GuideTableViewCell", bundle: nil)
        guideContentsTableView.registerNib(nibDefault, forCellReuseIdentifier: "GuideTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension GuideController: UITableViewDelegate {
    
}

extension GuideController: UITableViewDataSource {
    
    //テーブルの要素数を設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GuideTableViewCell") as? GuideTableViewCell
        
        //TODO: 読み込む静的なコンテンツの策定と
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
}