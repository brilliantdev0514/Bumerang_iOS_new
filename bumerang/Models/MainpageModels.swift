//
//  MainCatagoryModel.swift
//  bumerang
//
//  Created by RMS on 2019/9/5.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class MainCatagoryModel {

    var catagoryId : String = ""
    var catatoryImg : String = ""
    var catagoryColor :Int? = 0xFFFFFF
    var catagoryState : Bool = false

    init(catagoryId : String, catatoryImg :String, catagoryColor : Int, catagoryState : Bool) {

        self.catagoryId = catagoryId
        self.catatoryImg = catatoryImg
        self.catagoryColor = catagoryColor
        self.catagoryState = catagoryState
    }
}
class MainAdsModel {

    var adsId : Int = 0
    var adsImg : String?
    var adsTitle = ""
    var adsDescription  = ""
    var placeHolerImage = ""

    init(adsId : Int, adsImg :String, adsTitle: String, adsDescription : String) {

        self.adsId = adsId
        self.adsImg = adsImg
        self.adsTitle = adsTitle
        self.adsDescription = adsDescription
        self.placeHolerImage = Constants.arrPlaceHolerImage[adsId/11]
    }

    init(dict : JSON ) {

        self.adsId      = dict["adsId"].intValue
        self.adsImg     = dict["image_url"].stringValue
        self.adsTitle   = dict["title"].stringValue
        self.adsDescription = dict["description"].stringValue
        self.placeHolerImage = Constants.arrPlaceHolerImage[adsId/11]
    }

}

class MainFilterModel {

    var titleLbl = ""
    var filterLbls = [String]()
    var filterIDs = [Int]()
    var cellWidth : CGFloat = 0.0
    var logo : UIImage

    init(titleLbl: String, filterLbls: [String], filterIDs : [Int], cellWidth : CGFloat,logo: UIImage) {

        self.titleLbl = titleLbl
        self.filterLbls = filterLbls
        self.filterIDs = filterIDs
        self.cellWidth = cellWidth
        self.logo = logo
    }

}

class MainProductModel {
    
    var rental_status : Bool = false
    var owner_id    : Int = 0
    var product_id  : Int = 0
    var category    : Int = 0
    var title       : String = ""
    var room_number : String = ""
    var heating     : String = ""
    var furbished   : String = ""
    var fuel_type   : String = ""
    var gear_type   : String = ""
    var door_number : String = ""
    var car_type    : String = ""
    var bed_capacity : String = ""
    var person_capacity : String = ""
    var captan      : String = ""
    var gender      : String = ""
    var size        : String = ""
    var color       : String = ""
    var price       : Float = 0
    var price_type  : String = ""
    var deposit     : String = ""
    var description : String = ""
    var image_url   : String = ""
    var address     : String = ""
    var lat         : Double = 0
    var lng         : Double = 0
    var zip_code    : String = ""
    var score       : Float = 0.0
    var updated_at  : String = ""
    var created_at  : String = ""
    var service_fee : Float = 0
    
    var userinfo_fname : String = ""
    var userinfo_lname : String = ""
    var userinfo_avatar : String = ""
    var userinfo_rating : Float = 0.0
    var userinfo_mailState : Bool = false
    var userinfo_phoneState : Bool = false
    var userinfo_googleState : Bool = false
    var userinfo_faceState : Bool = false
    
        
    var placeHolerImage = "default_house_img"
    
    init(dict : JSON) {
        
        self.owner_id    = dict["owner_id"].intValue
        self.product_id  = dict["id"].intValue
        self.category    = dict["category"].intValue
        self.title       = dict["title"].stringValue
        self.room_number = dict["room_number"].stringValue
        self.heating     = dict["heating"].stringValue
        self.furbished   = dict["furbished"].stringValue
        self.fuel_type   = dict["fuel_type"].stringValue
        self.gear_type   = dict["gear_type"].stringValue
        self.car_type    = dict["car_type"].stringValue
        self.bed_capacity = dict["bed_capacity"].stringValue
        self.person_capacity = dict["person_capacity"].stringValue
        self.captan     = dict["captan"].stringValue
        self.gender     = dict["gender"].stringValue
        self.size       = dict["size"].stringValue
        self.color      = dict["color"].stringValue
        self.price      = dict["price"].floatValue
        self.price_type = dict["date_unit"].stringValue
        self.deposit       = dict["deposit"].stringValue
        self.description   = dict["description"].stringValue
        self.image_url     = dict["image_url"][0].stringValue
        self.address       = dict["address"].stringValue
        self.lat           = dict["lat"].doubleValue
        self.lng           = dict["lng"].doubleValue
        self.zip_code      = dict["zip_code"].stringValue
        self.rental_status = dict["rental_status"].boolValue
        self.score         = dict["score"].floatValue
        self.service_fee   = dict["service_fee"].floatValue
        
        self.updated_at = dict["updated_at"].stringValue
        self.created_at = dict["created_at"].stringValue
        
//        let ownerInfo = dict["owner_info"]
        self.userinfo_fname  = dict["owner_info"][0]["first_name"].stringValue
        self.userinfo_lname  = dict["owner_info"][0]["last_name"].stringValue
        self.userinfo_avatar = dict["owner_info"][0]["avatar_url"].stringValue
        self.userinfo_rating = dict["owner_info"][0]["score"].floatValue
        self.userinfo_mailState  = dict["owner_info"][0]["email_verified"].boolValue
        self.userinfo_phoneState = dict["owner_info"][0]["phone_verified"].boolValue
        
        
        self.userinfo_googleState = true
        if dict["owner_info"][0]["google_email"].stringValue.isEmpty {
            self.userinfo_googleState = false
        }
        self.userinfo_faceState = true
        if dict["owner_info"][0]["facebook_email"].stringValue.isEmpty {
            self.userinfo_faceState = false
        }
        
        
        self.userinfo_rating = 5.0
//        self.placeHolerImage = Constants.arrPlaceHolerImage[self.category-1]
//        setPlaceholdImamge(self.category)
    }
    
    
    init(category: Int, productId: Int, productImg: String, rentState: Bool, lblTop1: String, lblTop2: String, lblMid: String, price: Float, dateType: String) {

        self.category = category
        self.product_id = productId
        self.image_url = productImg
        self.rental_status = rentState
        self.title = lblTop1
        self.furbished = lblTop2
        self.fuel_type = lblMid
        self.price = price
        self.price_type = dateType
        
        self.placeHolerImage = Constants.arrPlaceHolerImage[self.category]
    }
}

//class ProductModels {
//    
//    var rental_status : String!
//    var owner_id    : String!
//    var product_id  : String!
//    var category    : String!
//    var title       : String!
//    var room_number : String!
//    var heating     : String!
//    var furbished   : String!
//    var fuel_type   : String!
//    var gear_type   : String!
//    var door_number : String!
//    var car_type    : String!
//    var bed_capacity : String!
//    var person_capacity : String!
//    var captan      : String!
//    var gender      : String!
//    var size        : String!
//    var color       : String!
//    var price       : String!
////    var price_type  : String!
//    var deposit     : String!
//    var description : String!
//    var image_url   : String!
//    var address     : String!
//    var lat         : String!
//    var lng         : String!
//    var zip_code    : String!
//    var score       : String!
//    var updated_at  : String!
//    var created_at  : String!
////    var service_fee : String!
//    var memberShipState: String!
//    var date_unit   : String!
//    var userinfo_fname : String!
//    var userinfo_lname : String!
//    var userinfo_avatar : String!
//    var userinfo_rating : String!
//    var userinfo_mailState : String!
//    var userinfo_phoneState : String!
//    var userinfo_googleState : String!
//    var userinfo_faceState : String!
//    
//        
//    var placeHolerImage = "default_house_img"
//    
//    init?(dictPro: [String: String]){
//    
////        guard let OwnerID = dictPro[ProductData.owner_id],
////            let ProductID = dictPro[ProductData.product_id]
////
////            else {
////                return nil
////        }
//        self.owner_id    = dictPro[ProductData.owner_id]
//        self.product_id  = dictPro[ProductData.product_id]
//        self.category    = dictPro[ProductData.category]
//        self.title       = dictPro[ProductData.title]
//        self.room_number = dictPro[ProductData.room_number]
//        self.heating     = dictPro[ProductData.heating]
//        self.furbished   = dictPro[ProductData.furbished]
//        self.fuel_type   = dictPro[ProductData.fuel_type]
//        self.gear_type   = dictPro[ProductData.gear_type]
//        self.door_number = dictPro[ProductData.door_number]
//        self.car_type    = dictPro[ProductData.car_type]
//        self.bed_capacity = dictPro[ProductData.bed_capacity]
//        self.person_capacity = dictPro[ProductData.person_capacity]
//        self.captan     = dictPro[ProductData.captan]
//        self.gender     = dictPro[ProductData.gender]
//        self.size       = dictPro[ProductData.size]
//        self.color      = dictPro[ProductData.color]
//        self.price      = dictPro[ProductData.price]
////                self.price_type = Price_type
//        self.deposit       = dictPro[ProductData.deposit]
//        self.description   = dictPro[ProductData.description]
//        self.image_url     = dictPro[ProductData.image_url]
//        self.address       = dictPro[ProductData.address]
//        self.lat           = dictPro[ProductData.lat]
//        self.lng           = dictPro[ProductData.lng]
//        self.zip_code      = dictPro[ProductData.zip_code]
//        self.rental_status = dictPro[ProductData.rental_status]
//        self.score         = dictPro[ProductData.score]
////        self.service_fee   = dictPro[ProductData.service_fee]
//        self.memberShipState = dictPro[ProductData.membershipState]
//        self.updated_at = dictPro[ProductData.updated_at]
//        self.created_at = dictPro[ProductData.created_at]
//        self.date_unit = dictPro[ProductData.date_unit]
//        
//    }
//}
//
