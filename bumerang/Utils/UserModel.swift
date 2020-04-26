//
//  UserModel.swift
//  bumerang
//
//  Created by RMS on 2019/9/14.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

var g_user : UserModel!

class UserModel {
    
    var userId = 0
    var first_name = ""
    var last_name = ""
    var email = ""
    var pwd = ""
    var google_email = ""
    var facebook_email = ""
    var user_type = ""
    var membership = ""
    var phone_num = ""
    var avatarUrl = ""
    var score = ""
    var address = ""
    var city = ""
    var location_lat = ""
    var location_lng = ""
    var email_verified = false
    var phone_verified = false
    var idcard_verified = false
    var verify_code = ""
    var updated_at = ""
    var created_at = ""
    
    init(userinfo : JSON) {
        userId      = userinfo["id"].intValue
        first_name  = userinfo["first_name"].stringValue
        last_name   = userinfo["last_name"].stringValue
        pwd         = userinfo["pwd"].stringValue
        email       = userinfo["email"].stringValue
        google_email = userinfo["google_email"].stringValue
        facebook_email = userinfo["facebook_email"].stringValue
        user_type   = userinfo["user_type"].stringValue
        membership  = userinfo["membership"].stringValue
        phone_num   = userinfo["phone_num"].stringValue
        avatarUrl   = userinfo["avatarUrl"].stringValue
        score       = userinfo["score"].stringValue
        address     = userinfo["address"].stringValue
        city        = userinfo["city"].stringValue
        location_lat = userinfo["lat"].stringValue
        location_lng = userinfo["lng"].stringValue
        email_verified = userinfo["email_verified"].boolValue
        phone_verified = userinfo["phone_verified"].boolValue
        idcard_verified = userinfo["idcard_verified"].boolValue
        verify_code = userinfo["verify_code"].stringValue
        updated_at  = userinfo["updated_at"].stringValue
        created_at  = userinfo["created_at"].stringValue
        
        var dateStrArr = self.updated_at.split(withMaxLength: 19)
        self.updated_at = dateStrArr[0]
        
        dateStrArr = self.created_at.split(withMaxLength: 19)
        self.created_at = dateStrArr[0]
    }
    
}
