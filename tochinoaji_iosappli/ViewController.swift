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
    fileprivate let pageNumber = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        introductionScrollView.delegate = self
    }

    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initMainScrollViewDefinition() {
        
        //ScrollViewの各種プロパティ値を設定する
        introductionScrollView.isPagingEnabled = true
        introductionScrollView.isScrollEnabled = true
        introductionScrollView.isDirectionalLockEnabled = false
        introductionScrollView.showsHorizontalScrollIndicator = false
        introductionScrollView.showsVerticalScrollIndicator = false
        introductionScrollView.bounces = false
        introductionScrollView.scrollsToTop = false
    }

    //メインのページへ遷移するためのアクション
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayContentsAction" {

            //TODO:値を渡す必要がある場合に記述をすること
            print("イントロダクションページからメインコンテンツページへ遷移すること")
        }
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //コンテンツ用のScrollViewを初期化
        initMainScrollViewDefinition()
            
        //スクロールビュー内のサイズを決定する
        introductionScrollView.contentSize = CGSize(
            width: CGFloat(Int(introductionScrollView.frame.width) * pageNumber),
            height: introductionScrollView.frame.height
        )
            
        //mainScrollViewの中に画像を一列に並べて配置する
        for i in 0...(pageNumber - 1) {
                
            let targetImageView = UIImageView(
                frame: CGRect(
                    x: Int(introductionScrollView.frame.width) * i,
                    y: 0,
                    width: Int(introductionScrollView.frame.width),
                    height: Int(introductionScrollView.frame.height)
                )
            )
            introductionScrollView.addSubview(targetImageView)
         }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UIScrollViewDelegate {
    
    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(_ scrollview: UIScrollView) {
        
        //現在表示されているページ番号を判別する
        let pageWidth = introductionScrollView.frame.width
        let fractionalPage = Double(introductionScrollView.contentOffset.x / pageWidth)

        //ボタン配置用のスクロールビューもスライドさせる
        let page = lround(fractionalPage)
        introductionPageControl.currentPage = page
    }
    
}

