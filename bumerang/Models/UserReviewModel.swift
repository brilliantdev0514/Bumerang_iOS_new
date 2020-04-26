//
//  UserInfoCells.swift
//  bumerang
//
//  Created by RMS on 2019/9/13.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserReviewModel {
    
    var userId    = 0
    var reviewId  = 0
    var avatarImg = ""
    var producTitle = ""
    var reveiwVal : Float = 0.0
    var reviewStr = ""
    var userName = ""
    var reviewDate = ""
    
    
    init(reviewId : Int, avatarImg :String, producTitle : String, reveiwVal : Float, reviewStr : String, userName : String, reviewDate : String) {
        
        self.reviewId = reviewId
        self.avatarImg = avatarImg
        self.producTitle = producTitle
        self.reveiwVal = reveiwVal
        self.reviewStr = reviewStr
        self.userName = userName
        self.reviewDate = reviewDate
    }
    
    init(dict : JSON ) {

        self.userId      = dict["user_info"][0]["avatar_url"].intValue
        self.reviewId    = dict["user_info"][0]["avatar_url"].intValue
        self.avatarImg   = dict["user_info"][0]["avatar_url"].stringValue
        self.producTitle = dict["user_info"][0]["avatar_url"].stringValue
        self.reveiwVal   = dict["user_info"][0]["avatar_url"].floatValue
        self.reviewStr   = dict["user_info"][0]["avatar_url"].stringValue
        self.userName    = dict["user_info"][0]["avatar_url"].stringValue
        self.reviewDate  = dict["user_info"][0]["avatar_url"].stringValue
        
    }
}

//class UserChatModel {
//    
//    var reportDate = ""
//    var reportContent = ""
//    var receiveState : Int = 1
//    
//    init(reportDate : String, reportContent : String, receiveState : Int) {
//        
//        self.reportDate = reportDate
//        self.reportContent = reportContent
//        self.receiveState = receiveState
//    }
//    
//    
//}
