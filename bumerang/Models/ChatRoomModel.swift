//
//  ChatRoomModel.swift
//  bumerang
//
//  Created by RMS on 2019/9/12.
//  Copyright © 2019 RMS. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatRoomModel {
    
    var senderId = ""
    var receiverId = ""
    var strMsg = ""
    var receiver_photo = ""
    var user_name = ""
    
    var attachfile = ""
    var time: Int64 = 0
    
//    init(senderId : Int, receiverId :Int, strDate :String, strMsg : String, userImageUrl : String) {
//
//        self.senderId = senderId
//        self.receiverId = receiverId
//        self.strDate = strDate
//        self.strMsg = strMsg
//        self.userImageUrl = userImageUrl
//    }
//
//    init(dic : JSON){
//
//    }
    
    
    class func parseMessageData(ary: NSArray) -> NSMutableArray {
          
          let muary = NSMutableArray()
          
          for index in 0 ..< ary.count {
              
              let dict = ary.object(at: index) as! [String: Any]
              
              let objList = ChatRoomModel()
              objList.strMsg = DataChecker .getValidationstring(dict: dict, key: "message")
              objList.receiver_photo = DataChecker.getValidationstring(dict: dict, key: "photo")
              objList.senderId = DataChecker .getValidationstring(dict: dict, key: "sender_id")
            objList.user_name = DataChecker .getValidationstring(dict: dict, key: "name")
              objList.time = Int64(DataChecker .getValidationstring(dict: dict, key: "time"))!
              
              muary.add(objList)
          }
          
          return muary
      }
    
}


class DataChecker: NSObject {

//    class func `init`(dict: [String: Any], key: String) -> String {
//
//        var str : String = ""
//
//        if let nm = dict[key] as? NSNumber {
//            str = nm.stringValue
//        } else if let int = dict[key] as? Int {
//            str = String(format: "%d", int)
//        } else if let st = dict[key] as? String {
//            str = st
//        }
//
//        return str
//    }
    class func getValidationstring(dict: [String: Any], key: String) -> String {
        var str : String = ""
        
        if let nm = dict[key] as? NSNumber {
            str = nm.stringValue
        } else if let int = dict[key] as? Int {
            str = String(format: "%d", int)
        } else if let st = dict[key] as? String {
            str = st
        }
        
        return str
    }
}
