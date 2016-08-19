//
//  BaseViewController.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/07/18.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

enum SideStatus {
    case Opened
    case Closed
}

enum ScrollViewTag: Int {
    case Slide
    case Contents
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

    private var status = SideStatus.Closed
    private var contentsScrollToken: dispatch_once_t = 0
    private var movingLabel: UILabel!
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        //デリゲートの設定
        slideContentsScroll.delegate = self
        mainContentsScroll.delegate = self
        navigationController?.delegate = self

        //ナビゲーションコントローラー関連の設定
        navigationController?.navigationBar.barTintColor = ColorConverter.colorWithHexString(ColorDefinition.Orange.rawValue)
        navigationController?.navigationBar.tintColor = ColorConverter.colorWithHexString(ColorDefinition.White.rawValue)

        let attrsMainTitle = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 15)!
        ]
        navigationItem.title = "土地の味"
        navigationController?.navigationBar.titleTextAttributes = attrsMainTitle

        let attrsMainButton = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Georgia-Bold", size: 13)!
        ]
        guideButton = UIBarButtonItem(title: "使い方", style: .Plain, target: self, action: #selector(BaseViewController.onClickGuideButton(_:)))
        guideButton.setTitleTextAttributes(attrsMainButton, forState: .Normal)
        navigationItem.rightBarButtonItem = guideButton

        //スクロールビューを識別するためのタグ情報
        slideContentsScroll.tag = ScrollViewTag.Slide.rawValue
        mainContentsScroll.tag = ScrollViewTag.Contents.rawValue
        
        //動くラベルの初期化
        movingLabel = UILabel()
    }

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //動的に配置する見た目要素は一度だけ実行する
        dispatch_once(&contentsScrollToken) { () -> Void in
            
            //コンテンツ用のScrollViewを初期化
            self.initScrollViewDefinition()

            //スクロールビュー内のサイズを決定する
            self.slideContentsScroll.contentSize = CGSizeMake(
                CGFloat(Int(self.slideContentsScroll.frame.width) / 3 * ContentsSetting.pageNaviList.count),
                self.slideContentsScroll.frame.height
            )
            
            //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
            for i in 0...(ContentsSetting.pageNaviList.count - 1) {
                
                //メニュー用のスクロールビューにボタンを配置
                let buttonElement: UIButton! = UIButton()
                self.slideContentsScroll.addSubview(buttonElement)
                
                buttonElement.frame = CGRectMake(
                    CGFloat(Int(self.slideContentsScroll.frame.width) / 3 * i),
                    CGFloat(0),
                    CGFloat(Int(self.slideContentsScroll.frame.width) / 3),
                    self.slideContentsScroll.frame.height
                )
                buttonElement.backgroundColor = UIColor.clearColor()
                buttonElement.setTitle(ContentsSetting.pageNaviList[i], forState: .Normal)
                buttonElement.titleLabel!.font = UIFont(name: "Georgia-Bold", size: 11)!
                buttonElement.tag = i
                buttonElement.addTarget(self, action: #selector(BaseViewController.buttonTapped(_:)), forControlEvents: .TouchUpInside)
                
            }

            //動くラベルの配置
            self.slideContentsScroll.addSubview(self.movingLabel)
            self.slideContentsScroll.bringSubviewToFront(self.movingLabel)
            self.movingLabel.frame = CGRectMake(
                CGFloat(0),
                CGFloat(SlideMenuSetting.movingLabelY),
                CGFloat(self.view.frame.width / 3),
                CGFloat(SlideMenuSetting.movingLabelH)
            )
            self.movingLabel.backgroundColor = UIColor.whiteColor()
            
            //サイドメニュー用のコンテナ関連のものを配置
            self.sideMenuCloseButton.frame = CGRectMake(
                CGFloat(0),
                CGFloat(0),
                self.view.frame.width,
                self.view.frame.height
            )
            self.sideMenuCloseButton.enabled = false
            self.sideMenuCloseButton.alpha = 0

            self.sideMenuContainer.frame = CGRectMake(
                CGFloat(SideMenuSetting.closedContainerX),
                CGFloat(0),
                CGFloat(SideMenuSetting.targetContainerW),
                self.view.frame.height
            )
            self.navigationController?.view.addSubview(self.sideMenuCloseButton)
            self.navigationController?.view.addSubview(self.sideMenuContainer)
            
            //メニューボタンの装飾
            self.sideMenuControlButton.layer.borderColor = ColorConverter.colorWithHexString(ColorDefinition.White.rawValue).CGColor
            self.sideMenuControlButton.layer.borderWidth = 2
            self.sideMenuControlButton.layer.cornerRadius = CGFloat(SideMenuSetting.sideMenuControlButtonRadius)
        }
    }

    //サイドメニューを開いた状態にするアクション
    @IBAction func sideMenuOpenAction(sender: AnyObject) {
        status = SideStatus.Opened
        changeSideMenuStatus(status)
    }

    //サイドメニューを閉じた状態にするアクション
    @IBAction func sideMenuCloseAction(sender: AnyObject) {
        status = SideStatus.Closed
        changeSideMenuStatus(status)
    }
    
    //サイドメニュー制御用のメソッド
    func changeSideMenuStatus(targetStatus: SideStatus) {

        if targetStatus == SideStatus.Opened {
            
            //サイドメニューを表示状態にする
            UIView.animateWithDuration(0.16, delay: 0, options: [], animations: {

                self.sideMenuCloseButton.enabled = true
                self.sideMenuCloseButton.alpha = 0.6

                self.sideMenuContainer.frame = CGRectMake(
                    CGFloat(SideMenuSetting.openedContainerX),
                    CGFloat(0),
                    CGFloat(SideMenuSetting.targetContainerW),
                    self.view.frame.height
                )

            }, completion: nil)
            
        } else {

            //サイドメニューを非表示状態にする
            UIView.animateWithDuration(0.16, delay: 0, options: [], animations: {

                self.sideMenuCloseButton.enabled = false
                self.sideMenuCloseButton.alpha = 0

                self.sideMenuContainer.frame = CGRectMake(
                    CGFloat(SideMenuSetting.closedContainerX),
                    CGFloat(0),
                    CGFloat(SideMenuSetting.targetContainerW),
                    self.view.frame.height
                )

            }, completion: nil)
        }
        
    }
    
    //コンテンツ用のUIScrollViewの初期化を行う
    private func initScrollViewDefinition() {
        
        //（重要）BaseViewControllerの「Adjust Scroll View Insets」のチェックを外しておく
        //タブバーの各プロパティ値を設定する
        slideContentsScroll.pagingEnabled = false
        slideContentsScroll.scrollEnabled = true
        slideContentsScroll.directionalLockEnabled = false
        slideContentsScroll.showsHorizontalScrollIndicator = false
        slideContentsScroll.showsVerticalScrollIndicator = false
        slideContentsScroll.bounces = false
        slideContentsScroll.scrollsToTop = false

        //コンテンツ部分の各プロパティ値を設定する
        mainContentsScroll.pagingEnabled = true
        mainContentsScroll.scrollEnabled = true
        mainContentsScroll.directionalLockEnabled = false
        mainContentsScroll.showsHorizontalScrollIndicator = true
        mainContentsScroll.showsVerticalScrollIndicator = false
        mainContentsScroll.bounces = false
        mainContentsScroll.scrollsToTop = false
    }
    
    //ボタンをタップした際に行われる処理
    func buttonTapped(button: UIButton){
        
        //押されたボタンのタグを取得
        let page: Int = button.tag
        
        //コンテンツを押されたボタンに応じて移動する
        moveToCurrentButtonLabelButtonTapped(page)
        moveFormNowDisplayContentsScrollView(page)
        moveFormNowButtonContentsScrollView(page)
    }

    //使い方ガイドボタンを押した際のアクション
    func onClickGuideButton(sender: UIBarButtonItem) {

        performSegueWithIdentifier("guideContentsAction", sender: nil)
        
        //TODO:値を渡す必要がある場合に記述をすること
        print("使い方ガイドページへ遷移すること")
    }

    //ボタン押下でコンテナをスライドさせる
    func moveFormNowDisplayContentsScrollView(page: Int) {
        
        UIView.animateWithDuration(0.16, delay: 0, options: [], animations: {
            
            self.mainContentsScroll.contentOffset = CGPointMake(
                CGFloat(Int(self.mainContentsScroll.frame.width) * page),
                CGFloat(0)
            )
            
        }, completion: nil)
    }
    
    //ボタンタップ時に動くラベルをスライドさせる
    func moveToCurrentButtonLabelButtonTapped(page: Int) {
        
        UIView.animateWithDuration(0.16, delay: 0, options: [], animations: {
            
            self.movingLabel.frame = CGRectMake(
                CGFloat(Int(self.view.frame.width) / 3 * page),
                CGFloat(SlideMenuSetting.movingLabelY),
                CGFloat((Int(self.view.frame.width) / 3)),
                CGFloat(SlideMenuSetting.movingLabelH)
            )
            
        }, completion: nil)
    }

    //スクロール量に応じて動くラベルを一緒に動かす
    func moveToCurrentButtonLabelContentsScrolled(page: Double) {
        
        UIView.animateWithDuration(0, delay: 0, options: [], animations: {
            
            self.movingLabel.frame = CGRectMake(
                CGFloat(Double(self.view.frame.width) / 3 * page),
                CGFloat(SlideMenuSetting.movingLabelY),
                CGFloat((Int(self.view.frame.width) / 3)),
                CGFloat(SlideMenuSetting.movingLabelH)
            )
            
        }, completion: nil)
    }

    //ボタンのスクロールビューをスライドさせる
    func moveFormNowButtonContentsScrollView(page: Int) {
        
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
        
        UIView.animateWithDuration(0.16, delay: 0, options: [], animations: {
            self.slideContentsScroll.contentOffset = CGPointMake(
                CGFloat(self.scrollButtonOffsetX),
                CGFloat(0)
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
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        if scrollview.tag == ScrollViewTag.Contents.rawValue {

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
