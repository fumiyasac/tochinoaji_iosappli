//
//  SideViewController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/07/22.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SideViewController: UIViewController {

    @IBOutlet weak var introContentsButton: UIButton!
    @IBOutlet weak var newinfoContentsButton: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    
    private let sectionCount = 1
    private let cellCount = SideMenuMaker.makeMenuList().count
    private let cellHeight = 64.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        menuTableView.registerNib(nibDefault, forCellReuseIdentifier: "SideMenuTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SideViewController: UITableViewDelegate {
    
    //セルの高さを返す ※高さが固定の場合は必須
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

}

extension SideViewController: UITableViewDataSource {

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
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuTableViewCell") as? SideMenuTableViewCell
        
        let sideMenu = SideMenuMaker.makeMenuList()[indexPath.row]

        cell!.categoryLabel.text = sideMenu[0]
        cell!.menuTextLabel.text = sideMenu[1]

        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }

}
