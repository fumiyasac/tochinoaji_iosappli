//
//  SlideBannerController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SlideBannerController: UIViewController {

    @IBOutlet weak var bannerSlideScrollView: UIScrollView!
    @IBOutlet weak var bannserSlidePageControl: UIPageControl!

    //バナーローテーション用のページ数
    let bannerPageNumber = 2

    //バナーローテーション用のページカウンター変数
    var bannerPageCounter = 0

    //バナーローテーション用のタイマー変数
    var timer: Timer!
    
    //レイアウト要素生成用のトークン値
    fileprivate var layoutOnceFlag: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerSlideScrollView.delegate = self

        //バナー画像のローテーション処理
        timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(SlideBannerController.bannerViewAnimate), userInfo: nil, repeats: true)
    }

    override func viewDidLayoutSubviews() {
        
        if layoutOnceFlag == false {
        
            //コンテンツ用のScrollViewを初期化
            self.initBannerScrollViewDefinition()
            
            bannerSlideScrollView.contentSize = CGSize(
                width: CGFloat(Int(bannerSlideScrollView.frame.width) * (bannerPageNumber + 1)),
                height: CGFloat(Int(bannerSlideScrollView.frame.height))
            )
            
            //UIImageViewを作成してScrollViewへ追加
            for i in 0...bannerPageNumber {
                
                let bannerImageView: UIImageView! = UIImageView(
                    frame: CGRect(
                        x: Int(bannerSlideScrollView.frame.width) * i,
                        y: 0,
                        width: Int(bannerSlideScrollView.frame.width),
                        height: Int(bannerSlideScrollView.frame.height)
                    )
                )
                
                //FIXME:ローカルのJSONデータを取得して解析したものを入れる予定
                switch (i) {
                case 0:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(hex: ColorDefinition.Red.rawValue)
                    break
                case 1:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(hex: ColorDefinition.Green.rawValue)
                    break
                case 2:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(hex: ColorDefinition.Gray.rawValue)
                    break
                default:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(hex: ColorDefinition.Red.rawValue)
                    break
                }
                bannerSlideScrollView.addSubview(bannerImageView)
            }
            layoutOnceFlag = true
        }

    }
    
    //バナー用のUIScrollViewの初期化を行う
    fileprivate func initBannerScrollViewDefinition() {
        
        //ScrollViewの各種プロパティ値を設定する
        bannerSlideScrollView.isPagingEnabled = false
        bannerSlideScrollView.isScrollEnabled = false
        bannerSlideScrollView.isDirectionalLockEnabled = true
        bannerSlideScrollView.showsHorizontalScrollIndicator = false
        bannerSlideScrollView.showsVerticalScrollIndicator = true
        bannerSlideScrollView.bounces = true
        bannerSlideScrollView.scrollsToTop = false
    }

    //スクロールを検知した際に行われる処理
    func bannerViewAnimate() {

        bannerPageCounter = (bannerPageCounter + 1) % (bannerPageNumber + 1)

        UIView.animate(withDuration: 0.6, delay: 0, options: [], animations: {
            self.bannerSlideScrollView.contentOffset.x = CGFloat(240 * self.bannerPageCounter)
        }, completion: nil)
    }

    @IBAction func bannerButtonAction(_ sender: AnyObject) {
        print("Banner Number:\(self.bannerPageCounter) tapped!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SlideBannerController: UIScrollViewDelegate {

    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(_ scrollview: UIScrollView) {
        
        //現在表示されているページ番号を判別する
        let pageWidth = bannerSlideScrollView.frame.width
        let fractionalPage = Double(bannerSlideScrollView.contentOffset.x / pageWidth)
        
        //ボタン配置用のスクロールビューもスライドさせる
        let page = lround(fractionalPage)
        bannserSlidePageControl.currentPage = page
    }
}
