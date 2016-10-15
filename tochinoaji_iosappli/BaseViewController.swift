//
//  BaseViewController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/07/18.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

enum SideStatus {
    case opened
    case closed
}

enum ScrollViewTag: Int {
    case slide
    case contents
}

struct ContentsSetting {
    static let pageNaviList: [String] = [
        "土地の味Top",
        "土地の味を探す",
        "今日のレシピはなに？",
        "セレクト記事集",
        "おすすめお取り寄せ"
    ]
}

struct SlideMenuSetting {
    static let movingLabelY = 38
    static let movingLabelH = 2
}

struct SideMenuSetting {
    static let openedContainerX = 0
    static let closedContainerX = -240
    static let targetContainerW = 240
    static let sideMenuControlButtonRadius = 25
}

class BaseViewController: UIViewController {

    @IBOutlet weak var sideMenuContainer: UIView!
    @IBOutlet weak var sideMenuCloseButton: UIButton!
    @IBOutlet weak var sideMenuControlButton: UIButton!
    
    @IBOutlet weak var slideContentsScroll: UIScrollView!
    @IBOutlet weak var mainContentsScroll: UIScrollView!

    fileprivate var status = SideStatus.closed
    fileprivate var contentsScrollToken: Int = 0
    fileprivate var movingLabel: UILabel!
    
    //各コンテンツ表示用のコンテナビュー
    @IBOutlet weak var firstContents: UIView!
    @IBOutlet weak var secondContents: UIView!
    @IBOutlet weak var thirdContents: UIView!
    @IBOutlet weak var fourthContents: UIView!
    @IBOutlet weak var fifthContents: UIView!
    
    //ボタンスクロール時の移動量
    var scrollButtonOffsetX: Int!

    //ナビゲーションコントローラーのアイテム
    var guideButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!

    //コンテンツ生成用のフラグ値
    fileprivate var layoutOnceFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //デリゲートの設定
        slideContentsScroll.delegate = self
        mainContentsScroll.delegate = self
        navigationController?.delegate = self

        //ナビゲーションコントローラー関連の設定
        navigationController?.navigationBar.barTintColor = ColorConverter.colorWithHexString(hex: ColorDefinition.Orange.rawValue)
        navigationController?.navigationBar.tintColor = ColorConverter.colorWithHexString(hex: ColorDefinition.White.rawValue)

        let attrsMainTitle = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 15)!
        ]
        navigationItem.title = "土地の味"
        navigationController?.navigationBar.titleTextAttributes = attrsMainTitle

        let attrsMainButton = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 13)!
        ]
        guideButton = UIBarButtonItem(title: "使い方", style: .plain, target: self, action: #selector(BaseViewController.onClickGuideButton(_:)))
        searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(BaseViewController.onClickSearchButton(_:)))
        
        guideButton.setTitleTextAttributes(attrsMainButton, for: UIControlState())
        searchButton.setTitleTextAttributes(attrsMainButton, for: UIControlState())

        let rightItemButtonArray: NSArray = [guideButton, searchButton]
        navigationItem.setRightBarButtonItems(rightItemButtonArray as? [UIBarButtonItem], animated: false)
        
        //スクロールビューを識別するためのタグ情報
        slideContentsScroll.tag = ScrollViewTag.slide.rawValue
        mainContentsScroll.tag = ScrollViewTag.contents.rawValue
        
        //動くラベルの初期化
        movingLabel = UILabel()
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //動的に配置する見た目要素は一度だけ実行する
        if layoutOnceFlag == false {

            //コンテンツ用のScrollViewを初期化
            initScrollViewDefinition()
            
            //スクロールビュー内のサイズを決定する
            slideContentsScroll.contentSize = CGSize(
                width: CGFloat(Int(slideContentsScroll.frame.width) / 3 * ContentsSetting.pageNaviList.count),
                height: slideContentsScroll.frame.height
            )
            
            //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
            for i in 0...(ContentsSetting.pageNaviList.count - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                let buttonElement: UIButton! = UIButton()
                slideContentsScroll.addSubview(buttonElement)
                
                buttonElement.frame = CGRect(
                    x: CGFloat(Int(slideContentsScroll.frame.width) / 3 * i),
                    y: CGFloat(0),
                    width: CGFloat(Int(slideContentsScroll.frame.width) / 3),
                    height: slideContentsScroll.frame.height
                )
                buttonElement.backgroundColor = UIColor.clear
                buttonElement.setTitle(ContentsSetting.pageNaviList[i], for: UIControlState())
                buttonElement.titleLabel!.font = UIFont(name: "Georgia-Bold", size: 11)!
                buttonElement.tag = i
                buttonElement.addTarget(self, action: #selector(BaseViewController.buttonTapped(_:)), for: .touchUpInside)
                
            }
            
            //動くラベルの配置
            slideContentsScroll.addSubview(self.movingLabel)
            slideContentsScroll.bringSubview(toFront: self.movingLabel)
            movingLabel.frame = CGRect(
                x: CGFloat(0),
                y: CGFloat(SlideMenuSetting.movingLabelY),
                width: CGFloat(self.view.frame.width / 3),
                height: CGFloat(SlideMenuSetting.movingLabelH)
            )
            movingLabel.backgroundColor = UIColor.white
            
            //サイドメニュー用のコンテナ関連のものを配置
            sideMenuCloseButton.frame = CGRect(
                x: CGFloat(0),
                y: CGFloat(0),
                width: self.view.frame.width,
                height: self.view.frame.height
            )
            sideMenuCloseButton.isEnabled = false
            sideMenuCloseButton.alpha = 0
            
            sideMenuContainer.frame = CGRect(
                x: CGFloat(SideMenuSetting.closedContainerX),
                y: CGFloat(0),
                width: CGFloat(SideMenuSetting.targetContainerW),
                height: self.view.frame.height
            )
            navigationController?.view.addSubview(sideMenuCloseButton)
            navigationController?.view.addSubview(sideMenuContainer)
            
            //メニューボタンの装飾
            sideMenuControlButton.layer.borderColor = ColorConverter.colorWithHexString(hex: ColorDefinition.White.rawValue).cgColor
            sideMenuControlButton.layer.borderWidth = 2
            sideMenuControlButton.layer.cornerRadius = CGFloat(SideMenuSetting.sideMenuControlButtonRadius)
        }
        
    }

    //サイドメニューを開いた状態にするアクション
    @IBAction func sideMenuOpenAction(_ sender: AnyObject) {
        status = SideStatus.opened
        changeSideMenuStatus(status)
    }

    //サイドメニューを閉じた状態にするアクション
    @IBAction func sideMenuCloseAction(_ sender: AnyObject) {
        status = SideStatus.closed
        changeSideMenuStatus(status)
    }
    
    //サイドメニュー制御用のメソッド
    func changeSideMenuStatus(_ targetStatus: SideStatus) {

        if targetStatus == SideStatus.opened {
            
            //サイドメニューを表示状態にする
            UIView.animate(withDuration: 0.16, delay: 0, options: [], animations: {

                self.sideMenuCloseButton.isEnabled = true
                self.sideMenuCloseButton.alpha = 0.6
                self.sideMenuContainer.frame = CGRect(
                    x: CGFloat(SideMenuSetting.openedContainerX),
                    y: CGFloat(0),
                    width: CGFloat(SideMenuSetting.targetContainerW),
                    height: self.view.frame.height
                )

            }, completion: nil)
            
        } else {

            //サイドメニューを非表示状態にする
            UIView.animate(withDuration: 0.16, delay: 0, options: [], animations: {

                self.sideMenuCloseButton.isEnabled = false
                self.sideMenuCloseButton.alpha = 0
                self.sideMenuContainer.frame = CGRect(
                    x: CGFloat(SideMenuSetting.closedContainerX),
                    y: CGFloat(0),
                    width: CGFloat(SideMenuSetting.targetContainerW),
                    height: self.view.frame.height
                )

            }, completion: nil)
        }
        
    }
    
    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //（重要）BaseViewControllerの「Adjust Scroll View Insets」のチェックを外しておく
        //タブバーの各プロパティ値を設定する
        slideContentsScroll.isPagingEnabled = false
        slideContentsScroll.isScrollEnabled = true
        slideContentsScroll.isDirectionalLockEnabled = false
        slideContentsScroll.showsHorizontalScrollIndicator = false
        slideContentsScroll.showsVerticalScrollIndicator = false
        slideContentsScroll.bounces = false
        slideContentsScroll.scrollsToTop = false

        //コンテンツ部分の各プロパティ値を設定する
        mainContentsScroll.isPagingEnabled = true
        mainContentsScroll.isScrollEnabled = true
        mainContentsScroll.isDirectionalLockEnabled = false
        mainContentsScroll.showsHorizontalScrollIndicator = true
        mainContentsScroll.showsVerticalScrollIndicator = false
        mainContentsScroll.bounces = false
        mainContentsScroll.scrollsToTop = false
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(_ button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveToCurrentButtonLabelButtonTapped(page)
        moveFormNowDisplayContentsScrollView(page)
        moveFormNowButtonContentsScrollView(page)
    }

    //使い方ガイドボタンを押した際のアクション
    func onClickSearchButton(_ sender: UIBarButtonItem) {
        
        //performSegue(withIdentifier: "", sender: nil)
        
        //TODO:値を渡す必要がある場合に記述をすること
        print("ご意見・ご感想ページへ遷移すること")
    }

    //使い方ガイドボタンを押した際のアクション
    func onClickGuideButton(_ sender: UIBarButtonItem) {

        performSegue(withIdentifier: "guideContentsAction", sender: nil)
        
        //TODO:値を渡す必要がある場合に記述をすること
        print("使い方ガイドページへ遷移すること")
    }

    //ボタン押下でコンテナをスライドさせる
    func moveFormNowDisplayContentsScrollView(_ page: Int) {
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [], animations: {
            
            self.mainContentsScroll.contentOffset = CGPoint(
                x: CGFloat(Int(self.mainContentsScroll.frame.width) * page),
                y: CGFloat(0)
            )
            
        }, completion: nil)
    }
    
    //ボタンタップ時に動くラベルをスライドさせる
    func moveToCurrentButtonLabelButtonTapped(_ page: Int) {
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [], animations: {
            
            self.movingLabel.frame = CGRect(
                x: CGFloat(Int(self.view.frame.width) / 3 * page),
                y: CGFloat(SlideMenuSetting.movingLabelY),
                width: CGFloat((Int(self.view.frame.width) / 3)),
                height: CGFloat(SlideMenuSetting.movingLabelH)
            )
            
        }, completion: nil)
    }

    //スクロール量に応じて動くラベルを一緒に動かす
    func moveToCurrentButtonLabelContentsScrolled(_ page: Double) {
        
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            
            self.movingLabel.frame = CGRect(
                x: CGFloat(Double(self.view.frame.width) / 3 * page),
                y: CGFloat(SlideMenuSetting.movingLabelY),
                width: CGFloat((Int(self.view.frame.width) / 3)),
                height: CGFloat(SlideMenuSetting.movingLabelH)
            )
            
        }, completion: nil)
    }

    //ボタンのスクロールビューをスライドさせる
    func moveFormNowButtonContentsScrollView(_ page: Int) {
        
        //Case1:ボタンを内包しているスクロールビューの位置変更をする
        if page > 0 && page < (ContentsSetting.pageNaviList.count - 1) {
            
            scrollButtonOffsetX = Int(slideContentsScroll.frame.width) / 3 * (page - 1)
            
        //Case2:一番最初のpage番号のときの移動量
        } else if page == 0 {
            
            scrollButtonOffsetX = 0
            
        //Case3:一番最後のpage番号のときの移動量
        } else if page == (ContentsSetting.pageNaviList.count - 2) {
            
            scrollButtonOffsetX = Int(slideContentsScroll.frame.width)
        }
        
        UIView.animate(withDuration: 0.16, delay: 0, options: [], animations: {
            self.slideContentsScroll.contentOffset = CGPoint(
                x: CGFloat(self.scrollButtonOffsetX),
                y: CGFloat(0)
            )
        }, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BaseViewController: UINavigationControllerDelegate {
    
}

extension BaseViewController: UIScrollViewDelegate {
    
    //スクロールが発生した際に行われる処理
    func scrollViewDidScroll(_ scrollview: UIScrollView) {
        
        if scrollview.tag == ScrollViewTag.contents.rawValue {

            //現在表示されているページ番号を判別する
            let pageWidth = mainContentsScroll.frame.width
            let fractionalPage = Double(mainContentsScroll.contentOffset.x / pageWidth)
            let page: NSInteger = lround(fractionalPage)

            //ボタン配置用のスクロールビューもスライドさせる
            moveFormNowButtonContentsScrollView(page)
            moveToCurrentButtonLabelContentsScrolled(fractionalPage)
        }
    }

}
