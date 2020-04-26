//
//  MyProductModel.swift
//  bumerang
//
//  Created by RMS on 10/25/19.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class MyProductModel {
    
    var categoryId = 0
    var productId = 0
    var productImg = ""
    var title     = ""
    var priceVal  = ""
    var priceType = ""
    var adsState  = ""
    var updated_at = Date()
    var created_at = Date()
    var adsCost : Float = 0
    var placeHolerImage = ""
    
    init(userinfo : JSON) {
        categoryId = userinfo["category"].intValue
        productId  = userinfo["id"].intValue
        productImg = userinfo["image_url"].stringValue
        title      = userinfo["title"].stringValue
        priceVal   = userinfo["price"].stringValue
        priceType  = userinfo["date_unit"].stringValue
        adsState   = userinfo["rental_status"].stringValue
        adsCost    = userinfo["adsCost"].floatValue
        
        self.placeHolerImage = Constants.arrPlaceHolerImage[categoryId]
        
        
        var dateStrArr = userinfo["updated_at"].stringValue.split(withMaxLength: 19)
        self.updated_at = getDateFormString(strDate: dateStrArr[0], format: "yyyy-MM-dd HH:mm:ss")
        
        dateStrArr = userinfo["created_at"].stringValue.split(withMaxLength: 19)
        self.created_at = getDateFormString(strDate: dateStrArr[0], format: "yyyy-MM-dd HH:mm:ss")
    }
    
    init(categoryId: Int, productId: Int, productImg: String, title: String, priceVal: String,
         priceType:String, adsState: String, updated_at: Date, created_at: Date, adsCost: Float) {
        self.categoryId = categoryId
        self.productId  = productId
        self.productImg = productImg
        self.title     = title
        self.priceVal  = priceVal
        self.priceType = priceType
        self.adsState  = adsState
        self.updated_at = updated_at
        self.created_at = created_at
        self.adsCost    = adsCost
        
        self.placeHolerImage = Constants.arrPlaceHolerImage[categoryId]

    }
    
}
