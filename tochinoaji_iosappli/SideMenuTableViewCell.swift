//
//  SideMenuTableViewCell.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import QuartzCore

struct MenuCellSetting {
    static let categoryLabelRadius = 8.0
}

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuThumbImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var menuTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryLabel.layer.cornerRadius = CGFloat(MenuCellSetting.categoryLabelRadius)
        categoryLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
