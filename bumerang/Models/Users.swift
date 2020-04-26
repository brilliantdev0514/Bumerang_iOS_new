//
//  User.swift
//  bumerang
//
//  Created by Billiard ball on 27.01.2020.
//  Copyright © 2020 RMS. All rights reserved.
//

import Foundation


class Users {
    
    var userId: String!
    var first_name: String!
    var last_name: String!
    var email: String!
    var pwd: String!
    var google_email: String!
    var facebook_email: String!
    var user_type: String!
    var membership: String!
    var phone_num: String!
    var avatarUrl: String!
    var score: String!
    var address: String!
    var city: String!
    var location_lat: String!
    var location_lng: String!
    var email_verified: String!
    var phone_verified: String!
    var idcard_verified: String!
//    var verify_code: String!
    var updated_at: String!
    var created_at: String!
    
    init(userid: String, firstname: String, lastname: String, emailaddress: String, password: String, googleemail: String, facebookemail: String, usertype: String, membership: String, phonenumber: String, avatarurl: String, score: String, address: String, city: String, lat: String, lng: String, emailverified: String, phoneverified: String, idcardverified: String, updated: String, created: String) {
        self.userId      = userid
        self.first_name  = firstname
        self.last_name   = lastname
        self.pwd         = password
        self.email       = emailaddress
        self.google_email = googleemail
        self.facebook_email = facebookemail
        self.user_type   = usertype
        self.membership  = membership
        self.phone_num   = phonenumber
        self.avatarUrl   = avatarurl
        self.score       = score
        self.address     = address
        self.city        = city
        self.location_lat = lat
        self.location_lng = lng
        self.email_verified = emailverified
        self.phone_verified = phoneverified
        self.idcard_verified = idcardverified
//        self.verify_code = verifycode
        self.updated_at  = updated
        self.created_at  = created
        
        var dateStrArr = self.updated_at.split(withMaxLength: 19)
        self.updated_at = dateStrArr[0]
        
        dateStrArr = self.created_at.split(withMaxLength: 19)
        self.created_at = dateStrArr[0]
    }
    
    init?(dict: [String: String]){
    
         guard let userid = dict[ShareData.Tuserid]
         else {
             return nil
         }
         self.userId      = userid
        self.first_name  = dict[ShareData.Tuserfirstname]
        self.last_name   = dict[ShareData.Tuserlastname]
        self.pwd         = dict[ShareData.Tuserpassword]
        self.email       = dict[ShareData.Tuseremail]
        self.google_email = dict[ShareData.TgoogleEmail]
        self.facebook_email = dict[ShareData.TfacebookEmail]
        self.user_type   = dict[ShareData.TuserType]
        self.membership  = dict[ShareData.TuserMemberShip]
        self.phone_num   = dict[ShareData.Tuserphone]
        self.avatarUrl   = dict[ShareData.Tuserphotoid]
        self.score       = dict[ShareData.TuserScore]
        self.address     = dict[ShareData.TuserAddress]
        self.city        = dict[ShareData.TuserCity]
        self.location_lat = dict[ShareData.Tuserlatitude]
        self.location_lng = dict[ShareData.Tuserlongitude]
        self.email_verified = dict[ShareData.TuserEmailVerified]
        self.phone_verified = dict[ShareData.TuserPhoneVerified]
        self.idcard_verified = dict[ShareData.TuserIdVerfied]
//         self.verify_code = verifycode
        self.updated_at  = dict[ShareData.TuserUpdatedAt]
        self.created_at  = dict[ShareData.TuserCreatedAt]
         
     }

    
}
