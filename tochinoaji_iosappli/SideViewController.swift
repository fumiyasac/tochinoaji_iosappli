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
    
    fileprivate let sectionCount = 1
    fileprivate let cellCount = SideMenuMaker.makeMenuList().count
    fileprivate let cellHeight = 64.5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        menuTableView.register(nibDefault, forCellReuseIdentifier: "SideMenuTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SideViewController: UITableViewDelegate {
    
    //セルの高さを返す ※高さが固定の場合は必須
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }

}

extension SideViewController: UITableViewDataSource {

    //テーブルの要素数を設定する ※必須
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    //テーブルの行数を設定する ※必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    //表示するセルの中身を設定する ※必須
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as? SideMenuTableViewCell
        
        let sideMenu = SideMenuMaker.makeMenuList()[(indexPath as NSIndexPath).row]

        cell!.categoryLabel.text = sideMenu[0]
        cell!.menuTextLabel.text = sideMenu[1]

        cell!.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

}
