//
//  ShareData.swift
//  bumerang
//
//  Created by Billiard ball on 28.01.2020.
//  Copyright © 2020 RMS. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class ShareData: NSObject
{
    
    static let user_table = "user"
    static var Tuserid = "id"
    static var Tuseremail = "email"
    static var Tuserfirstname = "firstName"
    static var Tuserlastname = "lastName"
    static var TgoogleEmail = "googleEmail"
    static var TfacebookEmail = "facebookEmail"
    static var TuserType = "userType"
    static var TuserMemberShip = "membership"
    static var Tuserphone = "phone"
    static var Tuserpassword = "password"
    static var TuserScore = "score"
    static var TuserAddress = "address"
    static var TuserCity = "city"
    static var TuserEmailVerified = "emailVerified"
    static var TuserPhoneVerified = "phoneVerified"
    static var TuserIdVerfied = "idCardVerified"
//    static var TuserVerifyCode = "verify_code"
    static var TuserUpdatedAt = "updatedAt"
    static var TuserCreatedAt = "createdAt"
    static var Tuserlatitude = "lat"
    static var Tuserlongitude = "lng"
    static var Tuserphotoid = "avatarUrl"
    static let dbUserRef = Database.database().reference().child(ShareData.user_table)
    
    static var user_info: Users!
    
    
    static func getDictFromUsersModel(user: Users) -> [String:String]
    {
        return [ShareData.Tuserid: user.userId, ShareData.Tuserfirstname: user.first_name, ShareData.Tuserlastname: user.last_name, ShareData.Tuseremail: user.email, ShareData.Tuserpassword: user.pwd, ShareData.TgoogleEmail: user.google_email, ShareData.TfacebookEmail: user.facebook_email, ShareData.TuserType: user.user_type, ShareData.TuserMemberShip: user.membership, ShareData.Tuserphone: user.phone_num, ShareData.Tuserphotoid: user.avatarUrl, ShareData.TuserScore: user.score, ShareData.TuserAddress: user.address, ShareData.TuserCity: user.city, ShareData.Tuserlatitude: user.location_lat, ShareData.Tuserlongitude: user.location_lng, ShareData.TuserEmailVerified: user.email_verified, ShareData.TuserPhoneVerified: user.phone_verified, ShareData.TuserIdVerfied: user.idcard_verified, ShareData.TuserUpdatedAt: user.updated_at, ShareData.TuserCreatedAt: user.created_at]
    }
    
    static func formattedDateString() -> String {
         
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        return formatter.string(from: Date())
       
    }
    
//
//    // ------------------
//
//
//
//    static var profile_photo: NSData! = nil
//
//    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
//
//    static let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//    struct feed_type {
//
//        let auction_create = "11"
//        let auction_update = "12"
//        let auction_follow = "13"
//        let auction_bid = "14"
//        let auction_bid_update = "15"
//        let auction_win = "16"
//
//        let book_request = "21"
//        let book_accept = "22"
//        let book_cancel = "23"
//        let book_add_time = "24"
//        let book_start = "25"
//        let book_video_sent = "26"
//        let book_video_seen = "27"
//
//        let follow_request = "31"
//        let follow_accept = "32"
//        let follow_cancel = "33"
//
//        let review_left = "41"
//
//        let msg_left = "51"
//        let msg_typing = "52"
//        let fee_msg = "53"
//
//        let other_popcoin_zero = "61"
//        let other_book_fee_charged = "62"
//        let other_book_fee_received = "63"
//        let other_book_fee_refunded = "64"
//        let other_book_add_time = "65"
//        let other_book_time_over = "66"
//        let other_book_process_fee = "67"
//
//        let promotion = "90"
//    }
//
//    static func getCurrentUID() -> String {
//        let user = Auth.auth().currentUser
//        if let user = user {
//          return user.uid
//
//        } else {
//            return ""
//        }
//    }
//
//    static func CurrentUSER() -> User {
//        return Auth.auth().currentUser!
//
//    }
//
    
    
}
class ProductData: NSObject {
    
    static var product_table = "product"
    static var rental_status = "rental_status"
    static var owner_id    = "owner_id"
    static var product_id  = "product_id"
    static var category    = "category"
    static var title       = "title"
    static var room_number = "room_number"
    static var heating     = "heating"
    static var furbished   = "furbished"
    static var fuel_type   = "fuel_type"
    static var gear_type   = "gear_type"
    static var door_number = "door_number"
    static var car_type    = "car_type"
    static var bed_capacity = "bed_capacity"
    static var person_capacity = "person_capacity"
    static var captan      = "captan"
    static var gender      = "gender"
    static var size        = "size"
    static var color       = "color"
    static var price       = "price"
    static var date_unit   = "date_unit"
//   static var price_type  = "price_type"
    static var deposit     = "deposit"
    static var description = "description"
    static var image_url   = "image_url"
    static var address     = "address"
    static var lat         = "lat"
    static var lng         = "lng"
    static var zip_code    = "zip_code"
    static var score       = "score"
    static var updated_at  = "updated_at"
    static var created_at  = "created_at"
    static var service_fee = "service_fee"
    static var membershipState = "membershipState"
    
    static var userinfo_fname = "userinfo_fname"
    static var userinfo_lname = "userinfo_lname"
    static var userinfo_avatar = "userinfo_avatar"
    static var userinfo_rating = "userinfo_rating"
    static var userinfo_mailState = "userinfo_mailState"
    static var userinfo_phoneState = "userinfo_phoneState"
    static var userinfo_googleState = "userinfo_googleState"
    static var userinfo_faceState = "userinfo_faceState"
    static var image_urls   =  NSMutableArray.self
    
    
    
    static let dbProRef = Database.database().reference().child(ProductData.product_table)
    static let rpProRef = Database.database().reference().child("ReportedProducts")
    static var product_info: ProductModels!
}
