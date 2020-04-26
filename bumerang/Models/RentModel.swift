//
//  RentModel.swift
//  bumerang
//
//  Created by RMS on 2019/9/11.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class RentModel{
    
    //commom Infomation
    var placeHolerImage = ""
    var stateBackColor : Int = 0x0000000
    var stateTxtColor : Int = 0x0000000
    
    //rent Infomation
    var rentState = ""
    var rentUserReceive = "No"
    var rentOwnerReceive = "No"
    var rentOwnerAcceptState = ""
    var rentUserMsg = ""
    var rentOwnerMsg = ""
    var rentStartDate = ""
    var rentEndDate = ""
    var rentRequestDate = ""
    var rentPrice : Float = 0
    var rentFee : Float = 0
   
    //product Infomation
    var productID : Int = 0
    var categoryID : Int = 0
    var prodTitle = ""
    var prodImage = ""
    var prodPriceVal : Float = 0
    var prodPriceType = ""
    
    //user Infomation
    var userId = 0
    var userFirstNmae = ""
    var userLastNmae = ""
    var userAvatar = ""
    var userAddr = ""
    var userEmail = ""
    var userphoneNum = ""
    var userGmail = ""
    var userFacebook = ""
    var userScore : Float = 0
    var userReviewNum :Int = 0
    
    //owner Infomation
    var ownerID = 0
    var ownerFistName = ""
    var ownerLastName = ""
    var ownerAvatar = ""
    var ownerAddr = ""
    var ownerEmail = ""
    var ownerphoneNum = ""
    var ownerGmail = ""
    var ownerFacebook = ""
    var ownerScore : Float = 0
    var ownerReviewNum :Int = 0
    
    init(dict: JSON) {

        self.rentState        = dict["owner_acceted_state"].stringValue
        self.rentUserReceive  = dict["user_received_state"].stringValue
        self.rentOwnerReceive = dict["owner_received_state"].stringValue
        self.rentOwnerAcceptState = dict["owner_acceted_state"].stringValue
        self.rentUserMsg      = dict["users_message"].stringValue
        self.rentOwnerMsg     = dict["users_message"].stringValue
        self.rentStartDate    = dict["start_date"].stringValue
        self.rentEndDate      = dict["end_date"].stringValue
        self.rentRequestDate  = dict["request_date"].stringValue
        self.rentPrice        = dict["rental_price"].floatValue
        self.rentFee          = dict["fee"].floatValue
        
        self.productID  = dict["product_id"].intValue
        self.categoryID = dict["product_info"][0]["category"].intValue
        self.prodTitle  = dict["product_info"][0]["title"].stringValue
        self.prodImage  = dict["product_info"][0]["image_url"].stringValue
        self.prodPriceVal   = dict["product_info"][0]["price"].floatValue
        self.prodPriceType  = dict["product_info"][0]["date_unit"].stringValue
        
        self.userId        = dict["user_id"].intValue
        
        self.userAvatar    = dict["user_info"][0]["avatar_url"].stringValue
        self.userAddr      = dict["user_info"][0]["address"].stringValue
        self.userEmail     = dict["user_info"][0]["email"].stringValue
        self.userFirstNmae = dict["user_info"][0]["first_name"].stringValue
        self.userFirstNmae = dict["user_info"][0]["last_name"].stringValue
        self.userphoneNum  = dict["user_info"][0]["phone"].stringValue
        self.userGmail     = dict["user_info"][0]["google_email"].stringValue
        self.userFacebook  = dict["user_info"][0]["facebook_email"].stringValue
        self.userScore     = dict["user_info"][0]["score"].floatValue
        
        self.ownerID        = dict["owner_id"].intValue
        self.ownerAvatar    = dict["owner_info"][0]["avatar_url"].stringValue
        self.ownerAddr      = dict["owner_info"][0]["address"].stringValue
        self.ownerEmail     = dict["owner_info"][0]["email"].stringValue
        self.ownerFistName  = dict["owner_info"][0]["first_name"].stringValue
        self.ownerLastName  = dict["owner_info"][0]["last_name"].stringValue
        self.ownerphoneNum  = dict["owner_info"][0]["phone"].stringValue
        self.ownerGmail     = dict["owner_info"][0]["google_email"].stringValue
        self.ownerFacebook  = dict["owner_info"][0]["facebook_email"].stringValue
        self.ownerScore     = dict["owner_info"][0]["score"].floatValue
        
        self.ownerScore = 3.6
        
        
        self.placeHolerImage = Constants.arrPlaceHolerImage[self.categoryID]
        setRentStateViewColor(self.rentState)
        
        
        var dateStrArr = self.rentRequestDate.split(withMaxLength: 19)
        self.rentRequestDate = dateStrArr[0]
        
        dateStrArr = self.rentStartDate.split(withMaxLength: 19)
        self.rentStartDate = dateStrArr[0]
        
        dateStrArr = self.rentEndDate.split(withMaxLength: 19)
        self.rentEndDate = dateStrArr[0]
        
    }
    
    private func setRentStateViewColor(_ rentState: String) {
        
        if rentState == Constants.requestStateText[0] {
            
            self.stateBackColor = 0xfb565e
            self.stateTxtColor = 0xffffff
        } else if rentState == Constants.requestStateText[1] {
            
            self.stateBackColor = 0x33d1b5
            self.stateTxtColor = 0x000000
        } else if rentState == Constants.requestStateText[2] {
            
            self.stateBackColor = 0xb0a847
            self.stateTxtColor = 0xffffff
        } else if rentState == Constants.requestStateText[3] {
            
            self.stateBackColor = 0xfb565e
            self.stateTxtColor = 0xffffff
        } else if rentState == Constants.requestStateText[4] {
            
            self.stateBackColor = 0x589add
            self.stateTxtColor = 0xffffff
        }
    }
    
}
