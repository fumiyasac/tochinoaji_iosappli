//
//  StockArticle.swift
//  tochinoaji_iosappli
//
//  Created by 酒井文也 on 2016/08/15.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

/*
import RealmSwift

//TODO: Realm内に保存しておく記事情報の定義をする
class StockArticle: Object {

    //Realmクラスのインスタンス
    static let realm = try! Realm()

    //id
    dynamic var id = 0

    //タイトル
    dynamic var title = ""

    //登録日
    dynamic var createDate = Date(timeIntervalSince1970: 0)

    //サムネイル写真
    dynamic fileprivate var _image: UIImage? = nil

    dynamic var image: UIImage? {

        //画像のSetter
        set {
            self._image = newValue
            if let value = newValue {
                self.imageData = UIImagePNGRepresentation(value)
            }
        }

        //画像のGetter
        get {
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data)
                return self._image
            }
            return nil
        }
    }

    dynamic fileprivate var imageData: Data? = nil

    //PrimaryKeyの設定
    override static func primaryKey() -> String? {
        return "id"
    }

    //保存しないプロパティの一覧
    override static func ignoredProperties() -> [String] {
        return ["image", "_image"]
    }

    //新規追加用のインスタンス生成メソッド
    static func create() -> StockArticle {
        let stockArticle = StockArticle()
        stockArticle.id = self.getLastId()
        return stockArticle
    }

    //プライマリキーの作成メソッド
    static func getLastId() -> Int {
        if let stockArticle = realm.objects(StockArticle).last {
            return stockArticle.id + 1
        } else {
            return 1
        }
    }

    //インスタンス保存用メソッド
    func save() {
        try! StockArticle.realm.write {
            StockArticle.realm.add(self)
        }
    }

    //インスタンス削除用メソッド
    func delete() {
        try! StockArticle.realm.write {
            StockArticle.realm.delete(self)
        }
    }

    //TODO: アプリ内にストックをしたデータの全件取得をする
    /*
    static func fetchAllStockArticleList() -> [StockArticle] {
        
        var stockArticle: Results<StockArticle>

        //TODO: 処理を組み立てる必要あり
        return stockArticle
    }
    */

}
*/
