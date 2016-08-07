//
//  ViewController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/07/17.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var introductionScrollView: UIScrollView!
    @IBOutlet weak var endIntroButton: UIButton!
    @IBOutlet weak var introductionPageControl: UIPageControl!

    //スライドの枚数
    private let pageNumber = 5

    //Container生成用のトークン値
    private var introScrollToken: dispatch_once_t = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        introductionScrollView.delegate = self
    }

    //コンテンツ用のUIScrollViewの初期化を行う
    private func initMainScrollViewDefinition() {
        
        //ScrollViewの各種プロパティ値を設定する
        introductionScrollView.pagingEnabled = true
        introductionScrollView.scrollEnabled = true
        introductionScrollView.directionalLockEnabled = false
        introductionScrollView.showsHorizontalScrollIndicator = false
        introductionScrollView.showsVerticalScrollIndicator = false
        introductionScrollView.bounces = false
        introductionScrollView.scrollsToTop = false
    }

    //メインのページへ遷移するためのアクション
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayContentsAction" {
            print("イントロダクションページからメインコンテンツページへ遷移すること")
        }
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //動的に配置する見た目要素は一度だけ実行する
        dispatch_once(&introScrollToken) { () -> Void in
            
            //コンテンツ用のScrollViewを初期化
            self.initMainScrollViewDefinition()

            //スクロールビュー内のサイズを決定する
            self.introductionScrollView.contentSize = CGSizeMake(
                CGFloat(Int(self.introductionScrollView.frame.width) * self.pageNumber),
                self.introductionScrollView.frame.height
            )
            
            //mainScrollViewの中に画像を一列に並べて配置する
            for i in 0...(self.pageNumber - 1) {
                
                let targetImageView = UIImageView(
                    frame: CGRect(
                        x: Int(self.introductionScrollView.frame.width) * i,
                        y: 0,
                        width: Int(self.introductionScrollView.frame.width),
                        height: Int(self.introductionScrollView.frame.height)
                    )
                )
                self.introductionScrollView.addSubview(targetImageView)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UIScrollViewDelegate {
    
    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        //現在表示されているページ番号を判別する
        let pageWidth = introductionScrollView.frame.width
        let fractionalPage = Double(introductionScrollView.contentOffset.x / pageWidth)

        //ボタン配置用のスクロールビューもスライドさせる
        let page = lround(fractionalPage)
        introductionPageControl.currentPage = page
    }
    
}

