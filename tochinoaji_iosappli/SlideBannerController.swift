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
    var timer: NSTimer!
    
    //レイアウト要素生成用のトークン値
    private var bannerScrollToken: dispatch_once_t = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        bannerSlideScrollView.delegate = self

        //バナー画像のローテーション処理
        timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(SlideBannerController.bannerViewAnimate), userInfo: nil, repeats: true)
    }

    override func viewDidLayoutSubviews() {
        
        //動的に配置する見た目要素は一度だけ実行する
        dispatch_once(&bannerScrollToken) { () -> Void in
            
            //コンテンツ用のScrollViewを初期化
            self.initBannerScrollViewDefinition()
            
            self.bannerSlideScrollView.contentSize = CGSizeMake(
                CGFloat(Int(self.bannerSlideScrollView.frame.width) * (self.bannerPageNumber + 1)),
                CGFloat(Int(self.bannerSlideScrollView.frame.height))
            )
            
            //UIImageViewを作成してScrollViewへ追加
            for i in 0...self.bannerPageNumber {
                
                let bannerImageView: UIImageView! = UIImageView(
                    frame: CGRect(
                        x: Int(self.bannerSlideScrollView.frame.width) * i,
                        y: 0,
                        width: Int(self.bannerSlideScrollView.frame.width),
                        height: Int(self.bannerSlideScrollView.frame.height)
                    )
                )
                
                //FIXME:ローカルのJSONデータを取得して解析したものを入れる予定
                switch (i) {
                case 0:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(ColorDefinition.Red.rawValue)
                    break
                case 1:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(ColorDefinition.Green.rawValue)
                    break
                case 2:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(ColorDefinition.Gray.rawValue)
                    break
                default:
                    bannerImageView.backgroundColor = ColorConverter.colorWithHexString(ColorDefinition.Red.rawValue)
                    break
                }
                self.bannerSlideScrollView.addSubview(bannerImageView)
            }

        }

    }
    
    //バナー用のUIScrollViewの初期化を行う
    private func initBannerScrollViewDefinition() {
        
        //ScrollViewの各種プロパティ値を設定する
        bannerSlideScrollView.pagingEnabled = false
        bannerSlideScrollView.scrollEnabled = false
        bannerSlideScrollView.directionalLockEnabled = true
        bannerSlideScrollView.showsHorizontalScrollIndicator = false
        bannerSlideScrollView.showsVerticalScrollIndicator = true
        bannerSlideScrollView.bounces = true
        bannerSlideScrollView.scrollsToTop = false
    }

    //スクロールを検知した際に行われる処理
    func bannerViewAnimate() {

        bannerPageCounter = (bannerPageCounter + 1) % (bannerPageNumber + 1)

        UIView.animateWithDuration(0.6, delay: 0, options: [], animations: {
            self.bannerSlideScrollView.contentOffset.x = CGFloat(240 * self.bannerPageCounter)
        }, completion: nil)
    }

    @IBAction func bannerButtonAction(sender: AnyObject) {
        print("Banner Number:\(self.bannerPageCounter) tapped!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SlideBannerController: UIScrollViewDelegate {

    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        //現在表示されているページ番号を判別する
        let pageWidth = bannerSlideScrollView.frame.width
        let fractionalPage = Double(bannerSlideScrollView.contentOffset.x / pageWidth)
        
        //ボタン配置用のスクロールビューもスライドさせる
        let page = lround(fractionalPage)
        bannserSlidePageControl.currentPage = page
    }
}
